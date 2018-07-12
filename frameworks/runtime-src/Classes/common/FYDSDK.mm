//
//  FYDSDK.m
//  aam2_client
//
//  Created by JingFeng on 2018/6/6.
//
//

#include "FYDSDK.h"
#import <Foundation/Foundation.h>
using namespace std;
FYDSDK* FYDSDK::__instance = nullptr;

FYDSDK* FYDSDK::getInstance()
{
    if(!__instance){
        __instance = new (nothrow)FYDSDK();
    }
    return __instance;
}

id invokeMethod(id instance,SEL aSelector,NSArray* array,Class cls){
    bool isInstanceFunc = true;
    NSMethodSignature *methodSignature = nil;
    if(instance){
        methodSignature =[[instance class] instanceMethodSignatureForSelector:aSelector];
    }
    //如果没有对应的实例方法,则查找静态方法
    if(methodSignature == nil){
        isInstanceFunc = false;
        methodSignature =[cls methodSignatureForSelector:aSelector];
    }
    if(methodSignature == nil)
    {
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return 0;
    }
 
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    if(isInstanceFunc && instance){
        [invocation setTarget:instance];
    }else{
        [invocation setTarget:cls];
    }
    [invocation setSelector:aSelector];
    //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
    NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
    NSInteger requireParamCount = array.count;
    NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
    for (NSInteger i = 0; i < resultParamCount; i++) {
        id  obj = array[i];
        [invocation setArgument:&obj atIndex:i+2];
    }
    [invocation invoke];
    //返回值处理
    id callBackObject = nil;
    if(methodSignature.methodReturnLength)
    {
        [invocation getReturnValue:&callBackObject];
    }
    return callBackObject;
}



// 默认情况下
static int excute(lua_State* L){

    const char * className = luaL_checkstring(L, 1);
    const char * funcName = luaL_checkstring(L, 2);

    FValue ret;

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    NSString* classStr = [NSString stringWithUTF8String:className];
    NSString* methodStr = [NSString stringWithUTF8String:funcName];
    Class classID = NSClassFromString(classStr);//转化函数
    if(!classID){
        return 0;
    }
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:3];
    for(int i = 0;i<10;i++){
        int idx = 3+i;
        if(lua_isnumber(L, idx)){
            float v = luaL_checknumber(L, idx);
            [array addObject:[NSNumber numberWithFloat:v]];
        }else if(lua_isstring(L, idx)){
            const char* v = luaL_checkstring(L, idx);
            [array addObject:[NSString stringWithUTF8String:v]];
        }
        else if(lua_isboolean(L, idx)){
            bool v = lua_toboolean(L, idx);
            [array addObject:[NSNumber numberWithBool:v && 1 || 0]];
        }else if(lua_isfunction(L, idx)){
            int funcId = LuaCBridge::getInstance(L)->retainFunc(idx);
            [array addObject:[NSNumber numberWithInteger:funcId]];
        }
    }
    int size = [array count];
    for (int i=0; i<size; i++) {
        methodStr = [methodStr stringByAppendingString:@":"];
    }
    SEL aSelector = NSSelectorFromString(methodStr);
    
    id instance = nil;
    for(int i = 0;i<1;i++){
        SEL sel = NSSelectorFromString(@"getInstance");
        if(!sel){
            break;
        }
        instance = [classID performSelector:sel];
        if(!instance){
            break;
        }
    }
    
    id result = invokeMethod(instance,aSelector,array,classID);
    if(result == nil){
        return 0;
    }
    

    if([result isKindOfClass:[NSString class]] == YES){
        const char * value = [result UTF8String];
        ret = value;
    }else if([result isKindOfClass:[NSNumber class]] == YES){
        NSString* type = [NSString stringWithFormat:@"%s",[result objCType]];
        if ([NSStringFromClass([result class])  isEqual: @"__NSCFNumber"]) {
            if([type isEqual: @"i"]){
                int value = [result integerValue];
                ret = value;
            }else if ([type isEqual: @"f"]){
                float value = [result floatValue];
                ret = value;
            }
            else if ([type isEqual: @"d"]){
                double value = [result doubleValue];
                ret = value;
            }else if ([type isEqual: @"c"]){
                int value = (int)[result charValue];
                ret = value;
            }
        }else if([NSStringFromClass([result class])  isEqual: @"__NSCFBoolean"])
        {
            NSString* type = [NSString stringWithFormat:@"%s",[result objCType]];
            if( [type isEqual: @"c"])
            {
                bool value = false;
                if([result boolValue]==YES)
                    value = true;
                ret = value;
            }
        }
    }else{
        NSLog(@"不支持的返回类型");
    }
#endif
    if(!ret.isNull()){
        switch (ret.getType()) {
            case FValue::Type::BOOLEAN:
                lua_pushboolean(L, ret.asBool());
            break;
            case FValue::Type::DOUBLE:
                lua_pushnumber(L, ret.asDouble());
            break;
            case FValue::Type::FLOAT:
                lua_pushnumber(L, ret.asFloat());
            break;
            case FValue::Type::INTEGER:
                lua_pushnumber(L, ret.asInt());
            break;
            case FValue::Type::STRING:
                lua_pushstring(L, ret.asString().c_str());
            break;
            default:
            break;
        }
        return 1;
    }
    return 0;
}

int luaopen_FYDSDK(lua_State* L)
{
    luaL_Reg reg[] = {
        { "excute", excute},
        { NULL, NULL },
    };
    luaL_register(L, "__FYDSDK__", reg);
    
    
    
    return 1;
}

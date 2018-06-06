//
//  PlatformSDK.m
//  aam2_client
//
//  Created by JingFeng on 2018/6/6.
//
//

#include "PlatformSDK.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "Utils.h"

#import <Foundation/Foundation.h>

PlatformSDK* PlatformSDK::__instance = nullptr;

PlatformSDK* PlatformSDK::getInstance()
{
    if(!__instance){
        __instance = new (nothrow)PlatformSDK();
    }
    return __instance;
}

void PlatformSDK::pushKeyValue(std::string key,FYD_FUNC value)
{
    __platMap[key] = value;
}

FYD_FUNC PlatformSDK::getValue(std::string key)
{
    return __platMap[key];
}

void PlatformSDK::registerList()
{
    Utils::getInstance()->registerFunc();
}

id performSelector(id instance,SEL aSelector,NSArray* array)
{
    NSMethodSignature *methodSignature =[[instance class] instanceMethodSignatureForSelector:aSelector];
    
    if(methodSignature == nil)
    {
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return 0;
    }
    else
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:instance];
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
}

// 默认情况下
static int excute(lua_State* L){
    
    const char * funcName = luaL_checkstring(L, 1);
    const char * className = luaL_checkstring(L, 2);

    Value ret;
    string funckey = string(className) + ":" + string(funcName);
    auto value = PlatformSDK::getInstance()->getValue(funckey);
    // 如果找到了那么执行
    if(value){
        ValueVector values;
        for(int i = 0;i<10;i++){
            int idx = 3+i;
            if(lua_isnumber(L, idx)){
                float v = luaL_checknumber(L, idx);
                values.push_back(Value(v));
            }else if(lua_isstring(L, idx)){
                const char* v = luaL_checkstring(L, idx);
                values.push_back(Value(v));
            }
            else if(lua_isboolean(L, idx)){
                bool v = lua_toboolean(L, idx);
                values.push_back(Value(v));
            }else if(lua_isfunction(L, idx)){
                int funcId = toluafix_ref_function(L, idx, 0);
                values.push_back(Value(funcId));
            }
        }
        ret = value(values);
    }else{
        printf("没有找到对应的C++方法%s\n",funckey.c_str());
        //如果没有找到,说明不是调用C++,而是调用OC 或者 JAVA
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
        printf("错误:ANDROID 执行文件错误，请检查文件目标\n");
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        printf("尝试调用OC方法\n");
        NSString* classStr = [NSString stringWithUTF8String:className];
        NSString* methodStr = [NSString stringWithUTF8String:funcName];
        Class classID = NSClassFromString(classStr);//转化函数
        SEL sel = NSSelectorFromString(@"getInstance");
        id instance = [classID performSelector:sel];
        
        
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
                int funcId = toluafix_ref_function(L, idx, 0);
                [array addObject:[NSNumber numberWithInteger:funcId]];
            }
        }
        int size = [array count];
        for (int i=0; i<size; i++) {
            methodStr = [methodStr stringByAppendingString:@":"];
        }
        
        SEL aSelector = NSSelectorFromString(methodStr);
        
        id result = performSelector(instance,aSelector,array);
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
    }
    
    if(!ret.isNull()){
        switch (ret.getType()) {
            case Value::Type::BOOLEAN:
                lua_pushboolean(L, true);
            break;
            case Value::Type::DOUBLE:
                lua_pushnumber(L, ret.asDouble());
            break;
            case Value::Type::FLOAT:
                lua_pushnumber(L, ret.asFloat());
            break;
            case Value::Type::INTEGER:
                lua_pushnumber(L, ret.asInt());
            break;
            case Value::Type::STRING:
                lua_pushstring(L, ret.asString().c_str());
            break;
            default:
            break;
        }
        return 1;
    }
    return 0;
}

int luaopen_PlatformSDK(lua_State* L)
{
    PlatformSDK::getInstance()->registerList();
    
    
    luaL_Reg reg[] = {
        { "excute", excute},
        
        { NULL, NULL },
    };
    luaL_register(L, "FYDSDK", reg);
    
    
    
    return 1;
}

/*
 example:
lua:
 local PlatformSDK = require "app/Common/PlatformSDK"
 local ret = PlatformSDK.testInvoke("Audio","字符串",false,2018)
 print("FYD-=---->>>RET = ",ret)
OC:  (Audio类)
 -(NSNumber*) testInvoke:(NSString*)str :(NSNumber*)bo :(NSNumber*)num
 {
 NSLog(@"AKJGIIELLK");
 BOOL A = bo.boolValue;
 float n = num.floatValue;
 
 return [NSNumber numberWithBool:YES];
 }
 
 */

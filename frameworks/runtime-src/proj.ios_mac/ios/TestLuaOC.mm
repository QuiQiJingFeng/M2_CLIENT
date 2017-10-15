//
//  TestLuaOC.m
//  aam2_client
//
//  Created by JingFeng on 2017/10/7.
//
//

#import "TestLuaOC.h"
#include "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"

@implementation TestLuaOC
/*
     local luaoc = require "cocos.cocos2d.luaoc"
     local args = {intValue=2,strValue="FYD",boolValue=true,call_back=function(params)
     print("FYD+++++")
     print(tostring(params))
     end}
     luaoc.callStaticMethod("TestLuaOC","staticFunc",args)
 */
+(void) staticFunc:(NSDictionary*) dic
{
    bool yes = [dic objectForKey:@"boolValue"];
    int number = [[dic objectForKey:@"intValue"] intValue];
    NSString* strValue = [dic objectForKey:@"strValue"];
    int call_back = [[dic objectForKey:@"call_back"] intValue];
    printf("FYD+++++++\n");

    [TestLuaOC callBackWithFuncID:call_back andParams:@{@"param1":@1,@"param2":@"2"}];
   
}
//返回的时候不要返回bool类型,并且返回值是一个table
+(void) callBackWithFuncID:(int) funcId andParams:(NSDictionary*) dic
{
    cocos2d::LuaObjcBridge::pushLuaFunctionById(funcId);
    cocos2d::LuaValueDict item;
    for (NSString *key in dic) {
        if([dic[key] isKindOfClass:[NSString class]]){
            item[[key UTF8String]] = cocos2d::LuaValue::stringValue([dic[key] UTF8String]);
        }else if([dic[key] isKindOfClass:[NSNumber class]]){
            item[[key UTF8String]] = cocos2d::LuaValue::floatValue([dic[key] floatValue]);
        }
    }
    cocos2d::LuaObjcBridge::getStack()->pushLuaValueDict(item);
    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
    cocos2d::LuaObjcBridge::releaseLuaFunctionById(funcId);
}
@end

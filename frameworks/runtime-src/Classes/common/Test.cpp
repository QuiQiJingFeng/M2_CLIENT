//
//  Test.cpp
//  cocosDemo
//
//  Created by JingFeng on 2018/6/27.
//
//

#include "Test.h"
#include "LuaCBridge.h"
Test* Test::__instance = nullptr;

Test* Test::getInstance()
{
    if(__instance == nullptr){
        __instance = new Test();
    }
    return __instance;
}

FValue Test::invoke1(FValueVector vector){
    int func_id = vector[4].asInt();
    
    LuaCBridge::getInstance()->executeFunctionByRetainId(func_id, vector);
    
    return FValue(198);
}

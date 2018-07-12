//
//  InvokeC.cpp
//  cocosDemo
//
//  Created by JingFeng on 2018/6/27.
//
//

#include "FYDC.h"
#include "LuaCBridge.h"

#include "Test.h"
#include "Utils.h"
#include "Email.h"

//所有需要被框架调用到的C++的方法,必须在这里进行注册
void registerCplusFuncList(){
    Test::getInstance()->registerFunc();
    Utils::getInstance()->registerFunc();
    Email::getInstance()->registerFunc();
}


FYDC* FYDC::__instance = nullptr;

FYDC* FYDC::getInstance()
{
    if(!__instance){
        __instance = new (std::nothrow)FYDC();
        
    }
    return __instance;
}

int excuteFYDC(lua_State* L){
    const char * className = luaL_checkstring(L, 1);
    const char * funcName = luaL_checkstring(L, 2);
    
    string funckey = string(className) + "::" + string(funcName);
    auto value = FYDC::getInstance()->get(funckey);
    if(!value){
        lua_pushstring(L, (funckey + " not special func").c_str());
        return 1;
    }
    FValueVector values;
    for(int i = 0;i<10;i++){
        int idx = 3+i;
        if(lua_isnumber(L, idx)){
            float v = lua_tonumber(L, idx);
            values.push_back(FValue(v));
        }else if(lua_isstring(L, idx)){
            const char* v = luaL_checkstring(L, idx);
            values.push_back(FValue(v));
        }
        else if(lua_isboolean(L, idx)){
            bool v = lua_toboolean(L, idx);
            values.push_back(FValue(v));
        }else if(lua_isfunction(L, idx)){
            int funcId = LuaCBridge::getInstance(L)->retainFunc(idx);
            values.push_back(FValue(funcId));
        }
    }
    
    FValue ret = value(values);
    
    if(!ret.isNull()){
        LuaCBridge::getInstance(L)->pushValueToStack(ret);
        return 1;
    }
    return 0;
}


int luaopen_FYDC(lua_State* L)
{
    //C++映射表注册
    registerCplusFuncList();
    
    luaL_Reg reg[] = {
        { "excute", excuteFYDC},
        { NULL, NULL },
    };
    luaL_register(L, "__FYDC__", reg);
    
    return 1;
}

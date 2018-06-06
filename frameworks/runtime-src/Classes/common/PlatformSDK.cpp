//
//  PlatformSDK.cpp
//  aam2_client
//
//  Created by JingFeng on 2018/6/4.
//
//

#include "PlatformSDK.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "Utils.h"

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


int excute(lua_State* L){
    
    const char * funcName = luaL_checkstring(L, 1);
    const char * className = luaL_checkstring(L, 2);
    
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
    Value ret;
    
    string funckey = string(className) + ":" + string(funcName);
    auto value = PlatformSDK::getInstance()->getValue(funckey);
    // 如果找到了那么执行
    if(value){
        ret = value(values);
    }else{
        printf("FYD--> CLASS OR FUNCTION NOT FOUND key->:%s\n",funckey.c_str());
    }

    if(!ret.isNull()){
        switch (ret.getType()) {
            case Value::Type::BOOLEAN:
                lua_pushboolean(L, ret.asBool());
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




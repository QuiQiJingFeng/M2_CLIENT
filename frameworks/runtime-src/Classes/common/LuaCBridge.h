//
//  LuaCBridge.hpp
//  cocosDemo
//
//  Created by JingFeng on 2018/7/7.
//
//

#ifndef LuaCBridge_hpp
#define LuaCBridge_hpp

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#ifdef __cplusplus
}
#endif
#include "FValue.h"
class LuaCBridge {
    LuaCBridge(lua_State* state);
    
public:
    static LuaCBridge* getInstance(lua_State* state = nullptr);
    int retainFunc(int dep);
    void releaseFunc(int retainId);
    void getFuncByRetainId(int retainId);
    
    void pushValueToStack(FValue& value);
    
    FValue parseStateParamaters();
    
    FValue executeFunctionByRetainId(int retainId, const FValueVector& vectorArgs);
public:
    int __retainId;
    static LuaCBridge* __instance;
    const char* __retainMap;
    lua_State * __state;
};

#endif /* LuaCBridge_hpp */

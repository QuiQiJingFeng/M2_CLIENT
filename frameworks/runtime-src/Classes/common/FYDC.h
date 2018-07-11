//
//  InvokeC.hpp
//  cocosDemo
//
//  Created by JingFeng on 2018/6/27.
//
//

#ifndef InvokeC_h
#define InvokeC_h

#ifdef __cplusplus
extern "C" {
#endif
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#ifdef __cplusplus
}
#endif
#include <stdio.h>
#include "FValue.h"
#include <map>
#include <functional>
using namespace std;

typedef std::function<FValue(FValueVector&)> CPLUS_FUNC;
#define REG_OBJ_FUNC(selector,target,cptype,key) FYDC::getInstance()->set(key,std::bind((FValue(cptype*)(FValueVector))(&selector),target,placeholders::_1));

int luaopen_FYDC(lua_State* L);

class FYDC{
private:
    FYDC(){};
    
private:
    static FYDC* __instance;
    std::map<std::string, CPLUS_FUNC> __functions;
    
public:
    static FYDC* getInstance();
    void callBack(int funcId,FValueVector vector);
    inline void set(string key,CPLUS_FUNC value){
        __functions[key] = value;
    };
    inline CPLUS_FUNC get(string key){
        return __functions[key];
    };
};

#endif /* InvokeC_h */

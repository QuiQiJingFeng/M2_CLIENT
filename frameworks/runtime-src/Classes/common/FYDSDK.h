//
//  FYDSDK.hpp
//  aam2_client
//
//  Created by JingFeng on 2018/6/4.
//
//

#ifndef FYDSDK_h
#define FYDSDK_h

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
#include "FYDHeaders.h"
#include "LuaCBridge.h"
int luaopen_FYDSDK(lua_State* L);


class FYDSDK{
private:
    FYDSDK(){};
    
private:
    static FYDSDK* __instance;

public:
    static FYDSDK* getInstance();
    
#if (FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID)
private:
    std::vector<std::string> __javaSearchPath;
public:
    void pushSearchPath(std::string path){
        __javaSearchPath.push_back(path);
    }
    std::vector<std::string>& getJavaSearchPath();
#endif
};


#endif /* FYDSDK_h */

//
//  PlatformSDK.hpp
//  aam2_client
//
//  Created by JingFeng on 2018/6/4.
//
//

#ifndef PlatformSDK_h
#define PlatformSDK_h

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
#include "cocos2d.h"
USING_NS_CC;

#include <functional>
using namespace std;
using namespace std::placeholders;

typedef std::function<Value(ValueVector&)> FYD_FUNC;
#define REGISTER_PLATFORM(selector,target,key) PlatformSDK::getInstance()->pushKeyValue(key,std::bind(&selector,target,placeholders::_1));

int luaopen_PlatformSDK(lua_State* L);


class PlatformSDK{
private:
    PlatformSDK(){};
    
private:
    static PlatformSDK* __instance;
    std::map<std::string, FYD_FUNC> __platMap;
    std::vector<std::string> __javaSearchPath;

public:
    static void registerList();
    static PlatformSDK* getInstance();
    void pushKeyValue(std::string key,FYD_FUNC value);
    FYD_FUNC getValue(std::string key);

    void pushSearchPath(string path){
        __javaSearchPath.push_back(path);
    }
    std::vector<std::string>& getJavaSearchPath();
    
    void callBack(int funcId,std::string value);
};


#endif /* PlatformSDK_h */

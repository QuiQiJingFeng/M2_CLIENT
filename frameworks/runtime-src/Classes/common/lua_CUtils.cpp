#include "cocos2d.h"
#include "lua_CUtils.h"
USING_NS_CC;

static int getDataFromFile(lua_State * L)
{
    const char * filepath = luaL_checkstring(L, 1);
    const std::string& path = cocos2d::FileUtils::getInstance()->fullPathForFilename(filepath);
    cocos2d::Data data = cocos2d::FileUtils::getInstance()->getDataFromFile(path);
    ;
    lua_pushlstring(L, (const char*)data.getBytes(), data.getSize());
    return 1;
}

int luaopen_CUtils(lua_State* L)
{
    luaL_Reg reg[] = {
        { "getDataFromFile", getDataFromFile },
        { NULL, NULL },
    };
    luaL_register(L, "CUtils", reg);
    
    return 1;
}

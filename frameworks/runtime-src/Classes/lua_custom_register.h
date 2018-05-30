#ifndef __LUA_TEMPLATE_DEFAULT_FRAMEWORKS_RUNTIME_SRC_CLASSES_LUA_MODULE_REGISTER_H__
#define __LUA_TEMPLATE_DEFAULT_FRAMEWORKS_RUNTIME_SRC_CLASSES_LUA_MODULE_REGISTER_H__

#include "lua.h"
#include "bit/bit.c"

#if __cplusplus
extern "C" {
#endif
    
    int luaopen_crypt(lua_State *L);
    int luaopen_md5_core(lua_State *L);
    int luaopen_protobuf_c(lua_State *L);
    
#if __cplusplus
}
#endif

CC_LUA_DLL int register_custom_function(lua_State* L){
    
    luaopen_bit(L);
    luaopen_crypt(L);
    luaopen_md5_core(L);
    luaopen_protobuf_c(L);
    
    return 0;
}

#endif  // __LUA_TEMPLATE_DEFAULT_FRAMEWORKS_RUNTIME_SRC_CLASSES_LUA_MODULE_REGISTER_H__


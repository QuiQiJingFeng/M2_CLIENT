#ifndef lua_CUtils_h
#define lua_CUtils_h

#ifdef __cplusplus
extern "C" {
#endif
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#ifdef __cplusplus
}
#endif

int luaopen_CUtils(lua_State* L);

#endif /* lua_CUtils_h */

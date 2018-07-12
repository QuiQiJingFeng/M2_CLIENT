//
//  LuaCBridge.cpp
//  cocosDemo
//
//  Created by JingFeng on 2018/7/7.
//
//

#include "LuaCBridge.h"

LuaCBridge::LuaCBridge(lua_State* state):__retainId(0),__retainMap("FYD_RETAIN_MAP"),__state(state)
{
    lua_pushstring(__state, __retainMap);
    lua_newtable(__state);
    lua_rawset(__state, LUA_REGISTRYINDEX);
}

LuaCBridge* LuaCBridge::__instance = nullptr;

LuaCBridge* LuaCBridge::getInstance(lua_State* state)
{
    if(!__instance){
        if(state == nullptr){
            return nullptr;
        }
        __instance = new LuaCBridge(state);
    }
    return __instance;
}
/*
    从注册表中拿到 FYD_RETAIN_MAP 这张表
    将funcId 存到这张表里面添加一个引用,这样就不会被lua的回收机制回收掉
 */
int LuaCBridge::retainFunc(int dep){
    __retainId++;
    lua_pushstring(__state, __retainMap);
    lua_rawget(__state, LUA_REGISTRYINDEX);
    lua_pushinteger(__state, __retainId);
    lua_pushvalue(__state, dep);
    lua_rawset(__state, -3);
    lua_pop(__state, 1);
    return __retainId;
}
void LuaCBridge::releaseFunc(int retainId){
    lua_pushstring(__state, __retainMap);      // -1 retainMap的key
    lua_rawget(__state, LUA_REGISTRYINDEX);    // -1 retainMap
    lua_pushinteger(__state, retainId);        // -1 retainId -2 retainMap
    lua_pushnil(__state);                      // -1 nil -2 retainId -3 retainMap
    lua_rawset(__state, -3);                   // -1 retainMap
    lua_pop(__state, 1);                       // 弹出栈顶的元素 恢复成之前的状态
}

//通过retainId将对应的方法压到栈顶
void LuaCBridge::getFuncByRetainId(int retainId){
    lua_pushstring(__state, __retainMap);    // -1  retainMap的key
    lua_rawget(__state, LUA_REGISTRYINDEX);  // -1  retainMap
    lua_pushinteger(__state, retainId);      // -1  retainId  -2  retainMap
    lua_rawget(__state, -2);                 // -1  func  -2 retainMap
    lua_remove(__state, -2);                 // -1  func
}

void LuaCBridge::pushValueToStack(FValue& value)
{
    switch (value.getType()) {
        case FValue::Type::BYTE:
            lua_pushstring(__state, value.asString().c_str());
            break;
        case FValue::Type::BOOLEAN:
            lua_pushboolean(__state, value.asBool());
            break;
        case FValue::Type::INTEGER:
            lua_pushnumber(__state, value.asInt());
            break;
        case FValue::Type::FLOAT:
            lua_pushnumber(__state, value.asFloat());
            break;
        case FValue::Type::DOUBLE:
            lua_pushnumber(__state, value.asDouble());
            break;
        case FValue::Type::UNSIGNED:
            lua_pushnumber(__state, value.asInt());
            break;
        case FValue::Type::STRING:
            lua_pushstring(__state, value.asString().c_str());
            break;
        case FValue::Type::MAP:{
            lua_newtable(__state);           // -1 table
            auto map = value.asFValueMap();
            for(auto iter = map.begin(); iter != map.end(); iter++){
                lua_pushstring(__state, iter->first.c_str());  // -1 key   -2 table
                pushValueToStack(iter->second);       // -1 value -2 key -3 table
                lua_rawset(__state, -3);                       // -1 table
            }
        }
            break;
        case FValue::Type::VECTOR:{
            lua_newtable(__state);           // -1 table
            auto vector = value.asFValueVector();
            for (int i = 0; i < vector.size(); i++) {
                lua_pushinteger(__state, i);
                pushValueToStack(vector[i]);
                lua_rawset(__state, -3);
            }
        }
            break;
        case FValue::Type::INT_KEY_MAP:{
            lua_newtable(__state);           // -1 table
            auto imap = value.asFValueMap();
            for(auto iter = imap.begin(); iter != imap.end(); iter++){
                lua_pushstring(__state, iter->first.c_str());  // -1 key   -2 table
                pushValueToStack(iter->second);       // -1 value -2 key -3 table
                lua_rawset(__state, -3);                       // -1 table
            }
        }
            break;
        default:
            break;
    }
}

FValue LuaCBridge::parseStateParamaters(){
    FValue ret;
    int top = -1;
    if(lua_isstring(__state,top)){
        ret = (lua_tostring(__state, top));
    }else if(lua_isnumber(__state, top)){
        ret = (lua_tonumber(__state, top));
    }else if(lua_isboolean(__state, top)){
        ret = (lua_toboolean(__state, top));
    }else if(lua_istable(__state, top)){
        FValueMap map;
        lua_pushnil(__state);
        /* 使用 '键' （在索引 -2 处） 和 '值' （在索引 -1 处）*/
        while(lua_next(__state, top)!=0){
            auto value = parseStateParamaters();
            auto key = parseStateParamaters();
            map[key.asString()] = value;
        }
        ret = map;
    }
 
    lua_pop(__state,top);
    return ret;
}

FValue LuaCBridge::executeFunctionByRetainId(int retainId, const FValueVector& vectorArgs)
{
    getFuncByRetainId(retainId); // -1 func
    if(!lua_isfunction(__state, -1)){
        //LOG retainId 没有绑定的方法
        lua_pop(__state, 1);
        return FValue("NO_RETAIN_FUNC");
    }
    
    for(FValue value:vectorArgs){
        pushValueToStack(value);
    }
    
    int numArgs = vectorArgs.size();
    int nargs = numArgs; //参数个数
    int nresult = 1;     //返回值个数(因为必须指定返回值的个数,所以lua层只能返回一个值到C++中)
    int errfunc = 0;     // 错误处理函数在栈中的索引 0表示没有错误处理函数
    int error = lua_pcall(__state, nargs, nresult, errfunc);
    if (error){
        const char * error = luaL_checkstring(__state, -1);
        const char * error2 = luaL_checkstring(__state, -2);
        printf("pcall %s\n%s\n",error,error2);
        //LOG 执行出错  =>  lua_tostring(state, - 1)
        lua_pop(__state, 1);    // 将错误消息弹出栈顶
        return FValue("excute failed!!!");
    }
    
    FValue ret = parseStateParamaters();
    
    return ret;
}

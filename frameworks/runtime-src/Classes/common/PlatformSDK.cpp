//
//  PlatformSDK.cpp
//  aam2_client
//
//  Created by JingFeng on 2018/6/4.
//
//

#include "PlatformSDK.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni/JniHelper.h>
#include <jni.h>
#endif
#include "Utils.h"
#include "Email.h"
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
    Email::getInstance()->registerFunc();
}

std::vector<std::string>& PlatformSDK::getJavaSearchPath()
{
    return __javaSearchPath;
}

void PlatformSDK::callBack(int funcId,std::string value)
{
    
}


int setJavaSearchPath(lua_State* L){
    auto instance = PlatformSDK::getInstance();
    //循环遍历 读取表中的参数值
    lua_pushnil(L);
    while(lua_next(L,-2))
    {
        if(lua_isstring(L,-1)){
            instance->pushSearchPath(lua_tostring(L,-1));
        }else{
            lua_pushstring(L,"ERROR:ONLY SUPPORT STRING TYPE");
            return 1;
        }
        lua_pop(L,1);
    }
    lua_pop(L,1);
    return 0;
}

// 默认情况下
int excute(lua_State* L){
    
    const char * funcName = luaL_checkstring(L, 1);
    const char * className = luaL_checkstring(L, 2);
    
    
    Value ret;
    string funckey = string(className) + ":" + string(funcName);
    auto value = PlatformSDK::getInstance()->getValue(funckey);
    ValueVector values;
    string sig = "(";
    for(int i = 0;i<10;i++){
        int idx = 3+i;
        if(lua_isnumber(L, idx)){
            float v = luaL_checknumber(L, idx);
            values.push_back(Value(v));
            sig += "F";
        }else if(lua_isstring(L, idx)){
            const char* v = luaL_checkstring(L, idx);
            values.push_back(Value(v));
            sig += "Ljava/lang/String;";
        }
        else if(lua_isboolean(L, idx)){
            bool v = lua_toboolean(L, idx);
            values.push_back(Value(v));
            sig += "Z";
        }else if(lua_isfunction(L, idx)){
            int funcId = toluafix_ref_function(L, idx, 0);
            values.push_back(Value(funcId));
            sig += "I";
        }
    }
    sig += ")";
    // 如果找到了那么执行
    if(value){
        ret = value(values);
    }else{
        printf("没有找到对应的C++方法%s\n",funckey.c_str());
        //如果没有找到,说明不是调用C++,而是调用OC 或者 JAVA
        #if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
            //调JAVA
            printf("尝试调用JAVA方法\n");

            bool isHave = false;
            auto searchPath = PlatformSDK::getInstance()->getJavaSearchPath();
            JniMethodInfo call;
            int idx;
            for(idx=0;idx<searchPath.size();idx++){
                string classPath = searchPath[idx] + "/" + className;
                isHave = JniHelper::getStaticMethodInfo(call, classPath.c_str(), "getInstance", "()Ljava/lang/Object;");
                if(isHave)
                    break;
            }
            if(!isHave) {
                lua_pushboolean(L,false);
                return 1;
            }

            jvalue *args = NULL;
            int count = values.size();
            if(count > 0){
                args = new jvalue[count];
                for(int i=0;i<count;i++){
                    Value value = values[i];
                    switch (value.getType()) {
                        case Value::Type::BOOLEAN:
                            args[i].z = value.asBool() ? JNI_TRUE :JNI_FALSE;;
                            break;
                        case Value::Type::DOUBLE:
                            args[i].f = value.asDouble();
                            break;
                        case Value::Type::FLOAT:
                            args[i].f = value.asDouble();
                            break;
                        case Value::Type::INTEGER:
                            args[i].i = value.asInt();
                            break;
                        case Value::Type::STRING:
                            args[i].l = call.env->NewStringUTF(value.asString().c_str());
                            break;
                        default:
                            break;
                    }
                }
            }

            jobject instance = call.env->CallStaticObjectMethod(call.classID,call.methodID);
            string classPath = searchPath[idx] + "/" + className;
            string temp[] = {"V","I","Z","F","Ljava/lang/String;"};
            for(idx=0;idx<5;idx++){
                string tsig = sig + temp[idx];
                isHave = JniHelper::getMethodInfo(call, classPath.c_str(), funcName, tsig.c_str());
                if(isHave) break;
            }

            if(!isHave) {
                lua_pushboolean(L,false);
                return 1;
            }
            switch(idx) {
                case 1:
                    ret = call.env->CallIntMethodA(instance,call.methodID,args);
                    break;
                case 2:
                    ret = call.env->CallBooleanMethodA(instance,call.methodID,args);
                    break;
                case 3:
                    ret = call.env->CallFloatMethodA(instance,call.methodID,args);
                    break;
                case 4:
                    jstring jstr;
                    jstr = (jstring) call.env->CallObjectMethodA(instance,call.methodID,args);
                    ret = call.env->GetStringUTFChars(jstr, NULL);
                    call.env->DeleteLocalRef(jstr);
                    break;
                default:
                    break;
            }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
            printf("错误:IOS 执行文件错误，请检查文件目标\n");
        #endif
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
        { "setJavaSearchPath", setJavaSearchPath},
        
        { NULL, NULL },
    };
    luaL_register(L, "FYDSDK", reg);
    
    
    
    return 1;
}




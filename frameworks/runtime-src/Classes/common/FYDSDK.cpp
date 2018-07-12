//
//  FYDSDK.cpp
//  aam2_client
//
//  Created by JingFeng on 2018/6/4.
//
//

#include "FYDSDK.h"
#if FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID
#include <jni/JniHelper.h>
#include <jni.h>
#endif
#include "cocos2d.h"
using namespace std;

FYDSDK* FYDSDK::__instance = nullptr;

FYDSDK* FYDSDK::getInstance()
{
    if(!__instance){
        __instance = new (std::nothrow)FYDSDK();
        
    }
    return __instance;
}

#if FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID
std::vector<std::string>& FYDSDK::getJavaSearchPath()
{
    return __javaSearchPath;
}
#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT void JNICALL Java_com_common_FYDSDK_callBackWithVector(JNIEnv *env, jclass clz,jint funcId,jobjectArray array) {
    int len = env->GetArrayLength(array);
    FValueVector vector;
    for(int i=0;i<len;i++){
        jobject obj = env->GetObjectArrayElement(array,i);
        jclass cls = env->GetObjectClass(obj);

        jclass String = env->FindClass("java/lang/String");
        jclass Integer = env->FindClass("java/lang/Integer");
        jclass Float = env->FindClass("java/lang/Float");
        jclass Double = env->FindClass("java/lang/Double");
        jclass Boolean = env->FindClass("java/lang/Boolean");

        if(env->IsInstanceOf(obj,String)){
            jstring jstr = (jstring)obj;
            const char *value = env->GetStringUTFChars(jstr, JNI_FALSE);
            vector.push_back(FValue(value));
            env->ReleaseStringUTFChars(jstr, value);
            env->DeleteLocalRef(jstr);
        }else if(env->IsInstanceOf(obj,Integer)){
            jfieldID id = env->GetFieldID(cls, "value", "I");
            jint value = env->GetIntField(obj, id);
            int param = (int)value;
            vector.push_back(FValue(param));
        }else if(env->IsInstanceOf(obj,Float)){
            jfieldID id = env->GetFieldID(cls, "value", "F");
            jfloat value = env->GetFloatField(obj, id);
            float param = (float)value;
            vector.push_back(FValue(param));
        }else if(env->IsInstanceOf(obj,Double)){
            jfieldID id = env->GetFieldID(cls, "value", "D");
            jdouble value = env->GetDoubleField(obj, id);
            double param = (double)value;
            vector.push_back(FValue(param));
        }else if(env->IsInstanceOf(obj,Boolean)){
            jfieldID id = env->GetFieldID(cls, "value", "Z");
            jboolean value = env->GetBooleanField(obj, id);
            bool param = (bool)value;
            vector.push_back(FValue(param));
        }
    }
    cocos2d::Director::getInstance()->getScheduler()->performFunctionInCocosThread([funcId,vector]{
        int id = (int)funcId;
        LuaCBridge::getInstance()->executeFunctionByRetainId(id, vector);
    });
}
    
#ifdef __cplusplus
}
#endif

 
#endif

int setJavaSearchPath(lua_State* L){
#if FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID
    auto instance = FYDSDK::getInstance();
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
#endif
    return 0;
}
#if FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID
FValue invokeStaticMethod(string& sig,cocos2d::JniMethodInfo& call,string& classPath,const char* funcName,jvalue *args,jclass cls){
    bool isHave = false;
    /*
     * 先检查是否存在对应的静态方法
     * */
    string temp[] = {"V","I","Z","D","Ljava/lang/String;"};
    int retType;
    for(retType = 0; retType < 5; retType++){
        string tsig = sig + temp[retType];
        isHave = cocos2d::JniHelper::getStaticMethodInfo(call, classPath.c_str(), funcName, tsig.c_str());
        if(isHave) break;
    }
    if(!isHave){
        return FValue("ERROR:NOT SPECIAL FUNCTION");
    }
    FValue ret;
    switch(retType) {
        case 0:
            call.env->CallStaticVoidMethodA(cls,call.methodID,args);
            break;
        case 1:
            ret = (int)call.env->CallStaticIntMethodA(cls,call.methodID,args);
            break;
        case 2:
            ret = (bool)call.env->CallStaticBooleanMethodA(cls,call.methodID,args);
            break;
        case 3:
            ret = (double)call.env->CallStaticDoubleMethodA(cls,call.methodID,args);
            break;
        case 4:
            jstring jstr;
            jstr = (jstring) call.env->CallStaticObjectMethodA(cls,call.methodID,args);
            ret = call.env->GetStringUTFChars(jstr, NULL);
            call.env->DeleteLocalRef(jstr);
            break;
        default:
            break;
    }
    return ret;
}

FValue invokeObjectMethod(string& sig,cocos2d::JniMethodInfo& call,string& classPath,const char* funcName,jvalue *args,jclass cls){
    jobject instance = call.env->CallStaticObjectMethod(call.classID,call.methodID);
    string temp[] = {"V","I","Z","D","Ljava/lang/String;"};
    bool isHave = false;
    int retType;
    for(retType = 0; retType < 5; retType++){
        string tsig = sig + temp[retType];
        isHave = cocos2d::JniHelper::getMethodInfo(call, classPath.c_str(), funcName, tsig.c_str());
        if(isHave) break;
    }

    if(!isHave){
        return invokeStaticMethod(sig,call,classPath, funcName,args,cls);
    }
    FValue ret;
    switch(retType) {
        case 0:
            call.env->CallVoidMethodA(instance,call.methodID,args);
            break;
        case 1:
            ret = (int)call.env->CallIntMethodA(instance,call.methodID,args);
            break;
        case 2:
            ret = (bool)call.env->CallBooleanMethodA(instance,call.methodID,args);
            break;
        case 3:
            ret = (double)call.env->CallDoubleMethodA(instance,call.methodID,args);
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
    return ret;
}
#endif
// 默认情况下
int excuteFYDSDK(lua_State* L){
    const char * className = luaL_checkstring(L, 1);
    const char * funcName = luaL_checkstring(L, 2);
    
    FValue ret;
#if FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID
    FValueVector values;
    string sig = "(";
    int idx = 3;
    do{
        if(lua_isnumber(L, idx)){
            double v = luaL_checknumber(L, idx);
            values.push_back(FValue(v));
            sig += "D";
        }else if(lua_isstring(L, idx)){
            const char* v = luaL_checkstring(L, idx);
            values.push_back(FValue(v));
            sig += "Ljava/lang/String;";
        }
        else if(lua_isboolean(L, idx)){
            bool v = lua_toboolean(L, idx);
            values.push_back(FValue(v));
            sig += "Z";
        }else if(lua_isfunction(L, idx)){
            int funcId = LuaCBridge::getInstance(L)->retainFunc(idx);
            values.push_back(FValue(funcId));
            sig += "I";
        }else if(lua_istable(L, idx)){
            lua_pushstring(L, "UNSUPPORT PARAMATER TABLE");
            return 1;
        }
        idx++;
    }while(idx <= 10);
    
    sig += ")";

    auto searchPath = FYDSDK::getInstance()->getJavaSearchPath();
    string classPath = "";
    jclass cls = nullptr;

    JNIEnv * env = cocos2d::JniHelper::getEnv();
    for(idx=0;idx<searchPath.size();idx++){
        classPath = searchPath[idx] + "/" + className;
        cls = env->FindClass(classPath.c_str());
        if(cls != nullptr){
            break;
        }else{
            env->ExceptionClear();
        }
    }
    if(cls == nullptr){
        lua_pushstring(L,"CLASS PATH NOT FOUOND");
        return 1;
    }
    cocos2d::JniMethodInfo call;
    bool isInstance = cocos2d::JniHelper::getStaticMethodInfo(call, classPath.c_str(), "getInstance", "()Ljava/lang/Object;");
    jvalue *args = NULL;
    int count = values.size();
    if(count > 0){
        args = new jvalue[count];
        for(int i=0;i<count;i++){
            FValue value = values[i];
            switch (value.getType()) {
                case FValue::Type::BOOLEAN:
                    args[i].z = value.asBool() ? JNI_TRUE :JNI_FALSE;
                    break;
                case FValue::Type::DOUBLE:
                    args[i].d = value.asDouble();
                    break;
                case FValue::Type::FLOAT:
                    args[i].f = value.asDouble();
                    break;
                case FValue::Type::INTEGER:
                    args[i].i = value.asInt();
                    break;
                case FValue::Type::STRING:
                    args[i].l = call.env->NewStringUTF(value.asString().c_str());
                    break;
                default:
                    break;
            }
        }
    }
    if(!isInstance){
        ret = invokeStaticMethod(sig,call,classPath, funcName,args,cls);
    }else{
        ret = invokeObjectMethod(sig,call,classPath, funcName,args,cls);
    }

    delete []args;  //释放内存
#endif

    if(!ret.isNull()){
        LuaCBridge::getInstance(L)->pushValueToStack(ret);
        return 1;
    }
    return 0;
}

int luaopen_FYDSDK(lua_State* L)
{
    luaL_Reg reg[] = {
        { "excute", excuteFYDSDK},
        { "setJavaSearchPath", setJavaSearchPath},
        
        { NULL, NULL },
    };
    luaL_register(L, "__FYDSDK__", reg);
    
    return 1;
}




LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
hellolua/main.cpp \
../../../Classes/AppDelegate.cpp \
../../../Classes/bit/bit.c \
../../../Classes/crypt/lsha1.c \
../../../Classes/crypt/lua-crypt.c \
../../../Classes/md5/md5.c \
../../../Classes/md5/md5lib.c \
../../../Classes/pbc/pbc-lua.c \
../../../Classes/common/JSONManager.cpp \
../../../Classes/common/Utils.cpp

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../../Classes \
$(LOCAL_PATH)/../../../Classes/bit \
$(LOCAL_PATH)/../../../Classes/crypt \
$(LOCAL_PATH)/../../../Classes/md5 \
$(LOCAL_PATH)/../../../Classes/pbc \
$(LOCAL_PATH)/../../../Classes/common 

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += pbc

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,pbc)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END

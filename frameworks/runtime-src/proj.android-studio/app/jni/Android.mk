LOCAL_PATH := $(call my-dir)


# --- bugly: 引用 libBugly.so ---
include $(CLEAR_VARS)
LOCAL_MODULE := bugly_native_prebuilt
LOCAL_SRC_FILES := prebuilt/$(TARGET_ARCH_ABI)/libBugly.so
include $(PREBUILT_SHARED_LIBRARY)
# --- bugly: end ---



include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua




# 遍历目录及子目录的函数
define walk
    $(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))
endef
 
# 遍历Classes目录
ALLFILES = $(call walk, $(LOCAL_PATH)/../../../Classes)

FILE_LIST := hellolua/main.cpp
# 从所有文件中提取出所有.cpp和.c文件文件
FILE_LIST += $(filter %.cpp %.c, $(ALLFILES))
 
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)    
                   
FILE_INCLUDES := $(shell find $(LOCAL_PATH)/../../../Classes -type d)

#LOCAL_C_INCLUDES := $(FILE_INCLUDES)
LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../../Classes \
$(LOCAL_PATH)/../../../Classes/bit \
$(LOCAL_PATH)/../../../Classes/crypt \
$(LOCAL_PATH)/../../../Classes/md5 \
$(LOCAL_PATH)/../../../Classes/pbc \
$(LOCAL_PATH)/../../../Classes/lame \
$(LOCAL_PATH)/../../../Classes/common \
$(LOCAL_PATH)/../../../Classes/bugly




# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += pbc
LOCAL_STATIC_LIBRARIES += bugly_crashreport_cocos_static
LOCAL_STATIC_LIBRARIES += bugly_agent_cocos_static_lua

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,pbc)
$(call import-module,external/bugly)
$(call import-module,external/bugly/lua)



# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END

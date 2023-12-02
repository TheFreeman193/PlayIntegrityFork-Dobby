LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := zygisk
LOCAL_SRC_FILES := main.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)

LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/*.c)
LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/common/*.c)
LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/third_party/xdl/*.c)

LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp
LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/common
LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/third_party/bsd
LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/third_party/lss
LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/third_party/xdl

ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
  LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/arch/arm/*.c)
  LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/arch/arm
endif

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/arch/arm64/*.c)
  LOCAL_C_INCLUDES += $(LOCAL_PATH)/shadowhook/shadowhook/src/main/cpp/arch/arm64
endif

LOCAL_STATIC_LIBRARIES := libcxx
LOCAL_LDLIBS := -llog
include $(BUILD_SHARED_LIBRARY)

include $(LOCAL_PATH)/libcxx/Android.mk

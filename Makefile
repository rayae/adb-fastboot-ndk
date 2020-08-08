ROOT_PATH = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR := $(ROOT_PATH)/build

ANDROID_NDK := $(ROOT_PATH)/android-ndk-r17b
NDK_BUILD := $(ANDROID_NDK)/ndk-build
NDK_APP_OUT := $(BUILD_DIR)/.obj
NDK_OUT := $(BUILD_DIR)/out

ADB_OUT := $(NDK_OUT)/adb
ADB_APP := $(ROOT_PATH)/Application_adb.mk

FASTBOOT_OUT := $(NDK_OUT)/fastboot
FASTBOOT_APP := $(ROOT_PATH)/Application_fastboot.mk

BORINGSSL_ROOT_DIR := $(ROOT_PATH)/src/boringssl
BORINGSSL_DIST_DIR := $(BORINGSSL_ROOT_DIR)/dist
BORINGSSL_BUILD_DIR := $(BORINGSSL_ROOT_DIR)/build


ABIS := armeabi-v7a arm64-v8a x86 x86_64
API := 23

$(shell mkdir -p $(BUILD_DIR))
$(shell mkdir -p $(NDK_OUT))

define build-boringssl
	$(shell mkdir -p $(BORINGSSL_BUILD_DIR)/$(1))
	@cd $(BORINGSSL_BUILD_DIR)/$(1) && cmake -DANDROID_ABI=$(1) \
	  -DANDROID_COMPILER_FLAGS=-Wno-tautological-constant-compare \
	  -DANDROID_COMPILER_FLAGS_CXX=-Wno-tautological-constant-compare \
	  -DCMAKE_TOOLCHAIN_FILE=$(ANDROID_NDK)/build/cmake/android.toolchain.cmake \
	  -DANDROID_NATIVE_API_LEVEL=$(API) \
	  -GNinja $(BORINGSSL_BUILD_DIR)/$(1) $(BORINGSSL_ROOT_DIR)

	@ninja -C $(BORINGSSL_BUILD_DIR)/$(1)
	@mkdir -p $(BORINGSSL_DIST_DIR)/$(1)
	cp -f $(BORINGSSL_BUILD_DIR)/$(1)/crypto/libcrypto.a $(BORINGSSL_DIST_DIR)/$(1)
	cp -f $(BORINGSSL_BUILD_DIR)/$(1)/decrepit/libdecrepit.a $(BORINGSSL_DIST_DIR)/$(1)
endef

all:adb fastboot

adb:boringssl
	$(NDK_BUILD) NDK_PROJECT_PATH=$(ROOT_PATH) APP_ABIS="$(ABIS)" NDK_APP_OUT=$(NDK_APP_OUT) NDK_APP_LIBS_OUT=$(ADB_OUT) NDK_APPLICATION_MK=$(ADB_APP)

fastboot:
	$(NDK_BUILD) NDK_PROJECT_PATH=$(ROOT_PATH) APP_ABIS="$(ABIS)" NDK_APP_OUT=$(NDK_APP_OUT) NDK_APP_LIBS_OUT=$(FASTBOOT_OUT) NDK_APPLICATION_MK=$(FASTBOOT_APP)

boringssl:
	$(foreach ABI, $(ABIS), $(call build-boringssl,$(ABI)))

.PHONY : clean
clean :
	@rm -rf $(BUILD_DIR) $(BORINGSSL_BUILD_DIR) $(BORINGSSL_DIST_DIR)


ifdef SIMULATOR
TARGET = simulator:clang:latest:8.0
else
TARGET = iphone:clang:latest:7.0
	ifeq ($(debug),0)
		ARCHS = armv7 arm64 arm64e
	else
		ARCHS = arm64 arm64e
	endif
endif

TWEAK_NAME = NoLowPowerMode30SecAutoLock

NoLowPowerMode30SecAutoLock_FILES = Tweak.x
NoLowPowerMode30SecAutoLock_CFLAGS = -fobjc-arc

ADDITIONAL_CFLAGS += -Wno-error=unused-variable -Wno-error=unused-function -Wno-error=unused-value -include Prefix.pch

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

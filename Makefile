TARGET := iphone:clang:11.2:10.0
ARCHS := arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = acnet
acnet_FILES = main.mm
acnet_CODESIGN_FLAGS = -Sentitlements.xml
acnet_PRIVATE_FRAMEWORKS += Preferences

include $(THEOS_MAKE_PATH)/tool.mk

#!/bin/sh

PROJECT=DataMine
TARGET=Storage

BUILD_CONFIGURATION=Release
TEST_DEVICE_DESTINATION='platform=iOS Simulator,name=iPhone 8,OS=13.6'

BUILD_PATH=Build
FRAMEWORK_DESTINATION=Frameworks

CARTHAGE_BUILD_PATH=./carthage-build.sh

.PHONY: build setup clean test

setup:

	set -e;

	# fix homebrew
	#sudo chown -R $(whoami) $(brew --prefix)/*;

	#install carthage
	#brew cleanup -d -v;
	#brew reinstall carthage;
	
	# chmod +x ${CARTHAGE_BUILD_PATH}
	chmod +x ${CARTHAGE_BUILD_PATH};

	# remove old setup and build if existed in project
	rm -rf ${BUILD_PATH};
	rm -rf Frameworks/*;
	rm -rf ./cconfig;

	#build
	${CARTHAGE_BUILD_PATH} update --platform iOS --no-use-binaries;
	
	rm -rf Carthage/Build/iOS/*bcsymbolmap;

	#copy libary to Frameworks
	mkdir Frameworks;
	cp -rf Carthage/Build/iOS/* ${FRAMEWORK_DESTINATION}/;
	
	#clean Carthage
	rm -rf Carthage;
	rm -rf Cartfile.resolved;
	
build:
	# remove old build
	rm -rf ${BUILD_PATH};
	mkdir ${BUILD_PATH};
	
	# build
	
	xcodebuild -target ${TARGET} -project ${PROJECT}.xcodeproj -configuration ${BUILD_CONFIGURATION} -arch x86_64 -arch arm64 -arch i386 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos";
	xcodebuild -target ${TARGET} -project ${PROJECT}.xcodeproj -configuration ${BUILD_CONFIGURATION} -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator";
 
 
 	# lipo
	lipo -create -output "${FRAMEWORK_DESTINATION}/${PROJECT}.framework/${PROJECT}" "${SRCROOT}/build/Release-iphoneos/${PROJECT}.framework/${FRAMEWORK_NAME}" "${SRCROOT}/build/Release-iphonesimulator/${PROJECT}.framework/${PROJECT}";

	
	#open folder build
	open ${BUILD_PATH};

test:
	xcodebuild build-for-testing \
  	-project ${PROJECT}.xcodeproj \
  	-scheme ${TARGET} \
  	-destination ${TEST_DEVICE_DESTINATION};

clean:
	rm -rf ${BUILD_PATH};
	rm -rf Carthage;
	rm -rf Cartfile.resolved;
	rm -rf ${FRAMEWORK_DESTINATION}/*;
	rm -rf ${PROJECT}.framework

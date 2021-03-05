#!/bin/sh

PROJECT=DataMine
SCHEME=DataMine

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
	cp -rf Carthage/Build/iOS/* ${FRAMEWORK_DESTINATION}/;
	
	#clean Carthage
	rm -rf Carthage;
	rm -rf Cartfile.resolved;
	
build:
	# remove old build
	rm -rf ${BUILD_PATH};
	mkdir ${BUILD_PATH};
	
	# build
	
	xcodebuild -target ${SCHEME} -project ${PROJECT}.xcodeproj -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos";
	xcodebuild -target ${SCHEME} -project ${PROJECT}.xcodeproj -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator";
 
 
 	# build
	lipo -create -output "${FRAMEWORK_DESTINATION}/${PROJECT}.framework/${PROJECT}" "${SRCROOT}/build/Release-iphoneos/${PROJECT}.framework/${FRAMEWORK_NAME}" "${SRCROOT}/build/Release-iphonesimulator/${PROJECT}.framework/${PROJECT}";
	
#	xcodebuild \
#	-project ${PROJECT}.xcodeproj \
#	-scheme ${SCHEME} \
#	-configuration ${BUILD_CONFIGURATION} \
#	-sdk iphoneos \
#	CONFIGURATION_BUILD_DIR=${BUILD_PATH} \
#	SKIP_INSTALL=NO \
#	clean build;
	
	#open folder build
	open ${BUILD_PATH};

test:
	xcodebuild build-for-testing \
  	-project ${PROJECT}.xcodeproj \
  	-scheme ${SCHEME} \
  	-destination ${TEST_DEVICE_DESTINATION};

clean:
	rm -rf ${BUILD_PATH};
	rm -rf Carthage;
	rm -rf Cartfile.resolved;
	rm -rf ${FRAMEWORK_DESTINATION}/*;
	rm -rf ${PROJECT}.framework

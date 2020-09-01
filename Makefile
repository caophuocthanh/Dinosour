#!/bin/sh

PROJECT=DataMine
SCHEME=DataMine

BUILD_CONFIGURATION=Release
TEST_DEVICE_DESTINATION='platform=iOS Simulator,name=iPhone 8,OS=13.6'

BUILD_PATH=Build
FRAMEWORK_DESTINATION=Frameworks

.PHONY: build setup clean test

setup:
	#install carthage
	brew install carthage;

	# remove old setup and build if existed in project
	rm -rf ${BUILD_PATH};
	rm -rf Frameworks/*;

	#build
	carthage update --platform iOS;
	
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
	xcodebuild \
	-project ${PROJECT}.xcodeproj \
	-scheme ${SCHEME} \
	-configuration ${BUILD_CONFIGURATION} \
	-sdk iphoneos \
	CONFIGURATION_BUILD_DIR=${BUILD_PATH} \
	clean build;
	
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

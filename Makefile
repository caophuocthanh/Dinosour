#!/bin/sh

PROJECT=DataMine
SCHEME=DataMine
BUILD_PATH=Build

.PHONY: build setup clean test

setup:
	
	#install carthage
	brew install carthage;

	# remove old setup and build if existed in project
	rm -rf ${BUILD_PATH};
	rm -rf Frameworks/Alamofire.framework;
	rm -rf Frameworks/RealmSwift.framework;
	rm -rf Frameworks/Realm.framework;

	#build
	carthage update --platform iOS;
	
	rm -rf Carthage/Build/iOS/*bcsymbolmap;

	#copy libary to Frameworks
	cp -rf Carthage/Build/iOS/* Frameworks/;
	
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
	-configuration Release \
	-sdk iphoneos \
	CONFIGURATION_BUILD_DIR=${BUILD_PATH} \
	clean build;
	
	#open folder build
	open ${BUILD_PATH}

test:
	xcodebuild build-for-testing \
  	-project ${PROJECT}.xcodeproj \
  	-scheme ${SCHEME} \
  	-destination 'platform=iOS Simulator,name=iPhone 8,OS=13.6'

clean:
	rm -rf ${BUILD_PATH};
	rm -rf Carthage;
	rm -rf Cartfile.resolved;
	rm -rf Frameworks/*;
	rm -rf ${PROJECT}.framework

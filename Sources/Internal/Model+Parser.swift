//
//  Model+JSON.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/7/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation

public extension NSObject  {
    
    func dictionary(forKeys keys: String...) -> [String : Any] {
        return self.dictionary(forKeys: keys)
    }

    func dictionary(forKeys keys: [String]) -> [String : Any] {
        var dictionary: [String: Any] = [:]
        let mirrored_object = Mirror(reflecting: self)
        
        for element in mirrored_object.children {
            if let label = element.label, keys.contains(label) {
                dictionary[label] = element.value
            }
        }
        
        if let superclassMirror = mirrored_object.superclassMirror {
            for element in superclassMirror.children {
                if let label = element.label, keys.contains(label) {
                    dictionary[label] = element.value
                }
            }
        }
        return dictionary
    }
    
    var dictionary: [String: Any] {
        
        var json: [String: Any] = [:]
        let mirrored_object = Mirror(reflecting: self)
        
        for element in mirrored_object.children {
            if let label = element.label {
                json[label] = element.value
            }
        }
        
        if let superclassMirror = mirrored_object.superclassMirror {
            for element in superclassMirror.children {
                if let label = element.label {
                    json[label] = element.value
                }
            }
        }
        
        return json.ignoreKeys(["_thread", "_updated_at", "_uid", "_created_at"])
    }
    
}

private extension Dictionary {
    
    func ignoreKeys(_ keys: [String]) -> Dictionary {
        let mainDict = NSMutableDictionary.init(dictionary: self)
        for _dict in mainDict {
            if let key = _dict.key as? String, keys.contains(key) {
                mainDict.removeObject(forKey: _dict.key)
            }
        }
        return mainDict as! Dictionary<Key, Value>
    }
    
    func ignoreNull() -> Dictionary {
        let mainDict = NSMutableDictionary.init(dictionary: self)
        for _dict in mainDict {
            if _dict.value is NSNull {
                mainDict.removeObject(forKey: _dict.key)
            }
            else if let key =  _dict.key as? String, _dict.value is NSDictionary {
                let test1 = (_dict.value as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                let mutableDict = NSMutableDictionary.init(dictionary: _dict.value as! NSDictionary)
                for test in test1 {
                    mutableDict.removeObject(forKey: test.key)
                }
                mainDict.removeObject(forKey: key)
                mainDict.setValue(mutableDict, forKey: key)
            }
            else if let key =  _dict.key as? String, _dict.value is NSArray {
                let mutableArray = NSMutableArray.init(object: _dict.value)
                for (index,element) in mutableArray.enumerated() where element is NSDictionary {
                    let test1 = (element as! NSDictionary).filter({ $0.value is NSNull }).map({ $0 })
                    let mutableDict = NSMutableDictionary.init(dictionary: element as! NSDictionary)
                    for test in test1 {
                        mutableDict.removeObject(forKey: test.key)
                    }
                    mutableArray.replaceObject(at: index, with: mutableDict)
                }
                mainDict.removeObject(forKey: key)
                mainDict.setValue(mutableArray, forKey: key)
            }
            else if let key =  _dict.key as? String, let value = _dict.value as? NSObject {
                mainDict.setValue(value.dictionary, forKey: key)
            }
        }
        return mainDict as! Dictionary<Key, Value>
    }
}


fileprivate extension KeyPath where Root: NSObject {
    var stringValue: String {
        NSExpression(forKeyPath: self).keyPath
    }
}


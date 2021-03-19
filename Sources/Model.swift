//
//  File.swift
//  
//
//  Created by Cao Phuoc Thanh on 8/27/20.
//

import Foundation
import RealmSwift
import Realm


public enum ObjectChanged {
    case Initial
    case Update
    case Delete
    case Error(Error)
}

public typealias ModelNotificationToken = RLMNotificationToken

open class Model: RealmSwift.Object, ObjectKeyIdentifiable {
        
    @objc dynamic public var id: Int = 0
    @objc dynamic public var _created_at: Double = Date().timeIntervalSince1970
    @objc dynamic public var _updated_at: Double = Date().timeIntervalSince1970
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        super.init()
        self.id = 0
    }
    
    public required init(id: Int) {
        super.init()
        self.id = id
    }
    
    private var listener: ModelNotificationToken?
    
    public func changed<T: Model>(block: @escaping (_: T?, _: ObjectChanged) -> Void) -> ModelOnChange<T> {
        return ModelOnChange(type: T.self, id: self.id) { (change, model) in
            block(model, change)
        }
    }
    
    public func write(block: @escaping (() throws -> Void)) throws {
        try database.write {
            try block()
        }
    }
    
    public func save() throws {
        try database.save(type: Self.self, value: self)
    }
    
    public func delete() throws {
        try database.delete(self)
    }
    
    public func isExisted() -> Bool {
        return database.object(id: self.id) != nil
    }
    
    public static func object<T: Model>(_ id: Int) -> T? {
        //print("object:", T.self)
        return database.object(id: id)
    }
     
    public static func all<T: Model>(_ id: Int) -> [T] {
        return database.objects()
    }
    
}


public class ModelOnChange<T: Model> {
    
    private var token: RLMNotificationToken? = nil
    private var notificationRunLoop: CFRunLoop? = nil

    init(type: T.Type, id: Int,  calback: @escaping (ObjectChanged, T?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Capture a reference to the runloop so that we can stop running it later
            self.notificationRunLoop = CFRunLoopGetCurrent()
            CFRunLoopPerformBlock(self.notificationRunLoop, CFRunLoopMode.defaultMode.rawValue) {
                let result = database.realm.objects(type).filter("id == \(id)")
                self.token = result.observe { (changes) in
                    switch changes {
                    case .initial(let result):
                        calback(ObjectChanged.Initial, result.last)
                    case .update(let result, deletions: let deletions, insertions: _, modifications: let modifications):
                        if deletions.count > 0 {
                            calback(ObjectChanged.Delete, result.last)
                        } else if modifications.count > 0 {
                            calback(ObjectChanged.Update, result.last)
                        }
                    case .error(let error):
                        calback(ObjectChanged.Error(error), nil)
                    }
                }
            }
            CFRunLoopRun()
        }
    }

    deinit {
        if let runloop = notificationRunLoop {
            CFRunLoopStop(runloop)
        }
    }
}

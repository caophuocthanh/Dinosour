//
//  File.swift
//  
//
//  Created by Cao Phuoc Thanh on 8/27/20.
//

import Foundation
import RealmSwift
import Realm

@objc open class Object: RealmSwift.Object, ObjectKeyIdentifiable {
    
    @objc dynamic public var id: Int = 0
    @objc dynamic public var _created_at: Double = Date().timeIntervalSince1970
    @objc dynamic public var _updated_at: Double = Date().timeIntervalSince1970
    
    internal var _uid: Int = 0
    internal var _thread: Thread = Thread.current
    
    public var this: Self? {
        guard self._thread == Thread.current else {
            return database.find(id: self._uid)
        }
        return self
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        //print(Self.self, "init")
        super.init()
        self.id = 0
        self._uid = 0
        self._thread = Thread.current
    }
    
    public required init(id: Int) {
        super.init()
        self.id = id
        self._uid = id
        self._thread = Thread.current
    }
    
    deinit {
        //print(Self.self, "deinit")
    }
    
    public func isExisted() -> Bool {
        return database.find(id: self._uid) != nil
    }

}

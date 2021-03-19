//
//  Save.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 3/18/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import RealmSwift
import Realm

internal extension Storage {
    
    func save<T>(type: T.Type, value: Model, update: SetType = .modified) throws where T : Model {
        print("save...")
        self.realm.beginWrite()
        switch update {
        case .all:
            self.realm.create(type, value: value, update: .all)
        case .modified:
            self.realm.create(type, value: value, update: .modified)
        case .error:
            self.realm.create(type, value: value, update: .error)
        }
        try self.realm.commitWrite()
    }
}

internal extension Storage {
    
    func safe_theard_save<T: Element>(_ model: T, update: Storage.SetType = .modified) throws {
        print("ksjdfh:", Thread.current)
        let ref = ThreadSafeReference(to: model)
        try self.queue.sync {
            guard let _model: T = self.realm.resolve(ref) else { return }
            self.realm.beginWrite()
            switch update {
            case .all:
                self.realm.create(T.self, value: _model, update: .all)
            case .modified:
                self.realm.create(T.self, value: _model, update: .modified)
            case .error:
                self.realm.create(T.self, value: _model, update: .error)
            }
            try self.realm.commitWrite()
        }
        
    }
}

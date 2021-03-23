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
    
    func insert<T>(type: T.Type, value: Model, update: SetType = .modified) throws where T : Model {
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

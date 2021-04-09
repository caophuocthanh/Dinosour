//
//  Object+Stored.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/9/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

public extension Object {
    
    func write(block: @escaping (() throws -> Void)) throws {
        try database.write { try block() }
    }
    
    func insert() throws {
        try database.insert(type: Self.self, value: self)
    }
    
    func delete() throws {
        if self._thread != Thread.current {
            if let model: Self = database.find(id: self._uid) {
                try model.delete()
            } else {
                print("delete nil", Self.self, self._uid)
            }
        } else {
            try database.delete(self)
        }
    }
}

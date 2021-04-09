//
//  Results.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 23/03/2021.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

final public class Many<T: Object> {

    internal let result: RealmSwift.Results<T>
    
    internal init(_ result: RealmSwift.Results<T>) {
        self.result = result
    }
    
    public var objects: [T] {
        return result.map { $0 }
    }
    
    public var ids: [Int] {
        return result.map { $0.id }
    }
    
    public var first: T? {
        return result.first
    }
    
}

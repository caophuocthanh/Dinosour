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

public class List<T: Model> {
    
    public enum ListChange<T> {
        case initial
        case update(deletions: [Int], insertions: [Int], modifications: [Int])
        case error(Error)
    }
    
    private let result: RealmSwift.Results<T>
    
    internal init(_ result: RealmSwift.Results<T>) {
        self.result = result
    }
    
    public var objects: [T] {
        return result.map { $0 }
    }
    
    public var first: T? {
        return result.first
    }
    
    public func observe(on queue: DispatchQueue? = nil, block: @escaping (ListChange<T>) -> Void) -> Model.NotificationToken {
        return self.result.observe(on: queue) { change in
            switch change {
            case .initial( _):
                block(ListChange<T>.initial)
            case .update(_, let deletions , let insertions, let modifications):
                block(ListChange<T>.update(
                        deletions: deletions,
                        insertions: insertions,
                        modifications: modifications)
                )
            case .error(let error):
                block(ListChange<T>.error(error))
            }
        }
    }
}

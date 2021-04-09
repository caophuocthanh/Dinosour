//
//  Many+Subcriber.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/9/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public extension Many {
    
    enum ManyChange<T> {
        case initial
        case update(deletions: [Int], insertions: [Int], modifications: [Int])
        case error(Error)
    }
    
    func subscribe(on queue: DispatchQueue? = nil, block: @escaping (ManyChange<T>) -> Void) -> Subscriber {
        let token = self.result.observe(on: queue) { change in
            switch change {
            case .initial( _):
                block(ManyChange<T>.initial)
            case .update(_, let deletions , let insertions, let modifications):
                block(ManyChange<T>.update(
                        deletions: deletions,
                        insertions: insertions,
                        modifications: modifications)
                )
            case .error(let error):
                block(ManyChange<T>.error(error))
            }
        }
        return Subscriber(token: token)
    }
}

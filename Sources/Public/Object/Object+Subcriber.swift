//
//  Object+Subcriber.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/9/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

public extension Object {
    
    typealias PropertyChange = (name: String, oldValue: Any?, newValue: Any?)
    typealias ObservableCalback<T: Object> = (T?, Object.ObjectChange<T>) -> Void
    
    enum ObjectChange<T: Object> {
        case initial(T)
        case update(T, [PropertyChange])
        case delete
        case error(Error)
    }
    
    func subscribe<T: Object>(on queue: DispatchQueue? = nil,_ calback: @escaping Object.ObservableCalback<T>)-> Subscriber? {
        guard let model: T = database.find(id: self._uid) else { return nil }
        let token = model.observe(on: queue) { (change: RealmSwift.ObjectChange<T>) in
            switch change {
            case .change(let model, let properties):
                calback(model, Object.ObjectChange<T>.update(model, properties.map { ($0.name, $0.oldValue, $0.newValue) }))
            case .deleted:
                calback(nil, Object.ObjectChange<T>.delete)
            case .error(let error):
                calback(model, Object.ObjectChange<T>.error(error))
            }
        }
        return Subscriber(token: token)
    }
}

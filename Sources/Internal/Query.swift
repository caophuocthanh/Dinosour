//
//  Query.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 3/18/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import RealmSwift

internal extension Storage {
    
    func find<T: Element>() -> [T] {
        return self.realm.objects(T.self).map{ $0 }.compactMap{ $0 }
    }
    
    func find<T: Element>(id: Int) -> T? {
        let query = "id == \(id)"
        return self.filter(query: query).first
    }
    
    func filter<Value: Equatable, T: Element, E: Any>(
        by keyPath: KeyPath<T, Value>,
        equal compareValue: E) -> List<T> {
        let query = "\(keyPath.stringValue) == \(compareValue)"
        return self.filter(query: query)
    }
    
    func filter<Value: Equatable, T: Element, E: Any>(
        by keyPath: KeyPath<T, Value>,
        operator basicOperator: BasicOperator,
        to compareValue: E) -> List<T> {
        let query = "\(keyPath.stringValue) \(basicOperator.string) \(compareValue)"
        return self.filter(query: query)
    }
    
    func filter<Value: Equatable, T: Element>(
        by keyPath: KeyPath<T, Value>,
        in strings: [String]) -> List<T> {
        let string = "{\(strings.map { "'\($0)'"}.joined(separator: ","))}"
        let query = "%\(keyPath.stringValue) IN \(string)"
        return self.filter(query: query)
    }
    
    func filter<T: Element>(query string: String) -> List<T> {
        print("[",T.self,"]","- query: \"\(string)\"")
        let result: Results<T> = self.realm.objects(T.self).filter(string)
        return List<T>(result)
    }

}

extension KeyPath where Root: NSObject {
    var stringValue: String {
        NSExpression(forKeyPath: self).keyPath
    }
}

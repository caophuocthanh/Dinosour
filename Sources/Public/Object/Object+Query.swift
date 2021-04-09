//
//  Object+Query.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/9/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation

public extension Object {
    
    static func find(id: Int) -> Self? {
        if let model: Self = database.find(id: id) {
            model._uid = model.id
            model._thread = Thread.current
            return model
        }
        return nil
    }
    
    static func find<T: Object>() -> [T] {
        let result: [T] = database.find()
        for model in result {
            model._uid = model.id
            model._thread = Thread.current
        }
        return result
    }
    
    static func filter<Value: Equatable, T: Object, E: Any>(
        by keyPath: KeyPath<T, Value>,
        equal compareValue: E) -> Many<T> {
        return database.filter(by: keyPath, operator: .equal, to: compareValue)
    }
    
    static func filter<Value: Equatable, T: Object, E: Any>(
        by keyPath: KeyPath<T, Value>,
        operator basicOperator: Operator,
        to compareValue: E) -> Many<T> {
        return database.filter(by: keyPath, operator: basicOperator, to: compareValue)
    }
    
    static func filter<Value: Equatable, T: Object>(
        by keyPath: KeyPath<T, Value>,
        in strings: [String]) -> Many<T> {
        return database.filter(by: keyPath, in: strings)
    }
    
    static func filter<T: Object>(query string: String) -> Many<T> {
        return database.filter(query: string)
    }

}

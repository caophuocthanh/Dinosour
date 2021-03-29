//
//  Operator.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 24/03/2021.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

// https://academy.realm.io/posts/nspredicate-cheatsheet/
public enum BasicOperator {
    
    case equal
    case notEqual
    case greater
    case greaterOrEqual
    case less
    case lessOrEqual
    
    var string: String {
        switch self  {
        case .equal: return "=="
        case .notEqual: return "!="
        case .greater: return ">"
        case .less: return "<"
        case .greaterOrEqual: return ">="
        case .lessOrEqual: return "<="
        }
    }
}

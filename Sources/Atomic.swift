//
//  Atomic.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 3/23/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

@propertyWrapper
internal class Atomic<Value> {
    private var queue = DispatchQueue(label: "Atomic", attributes: [], target: DispatchQueue.global())
    private var value: Value
    internal var wrappedValue: Value {
        set {
            self.queue.sync {
                self.value = newValue
            }
        }
        get {
            return self.queue.sync {
                return self.value
            }
        }
    }
    
    internal init(wrappedValue: Value) {
        self.value = wrappedValue
    }
}

@propertyWrapper
final public class Capitalized<Value> {
    public var wrappedValue: Value
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

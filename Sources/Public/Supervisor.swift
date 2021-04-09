//
//  Monitor.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/9/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

public class Supervisor {
    
    public init() {}
    
    deinit {
        print(self,"deinit")
    }
    
    internal var tokens: [Subscriber] = [] {
        didSet{
            print(self, "add token", tokens.count)
        }
    }
}

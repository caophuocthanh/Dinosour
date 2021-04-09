//
//  NSObject+Extensions.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 09/04/2021.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation

extension NSObject {
    
    public var className: String {
        return String(describing: type(of: self))
    }
    
}

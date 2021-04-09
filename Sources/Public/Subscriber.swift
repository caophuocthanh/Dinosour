//
//  Subscriber.swift
//  Storage
//
//  Created by Cao Phuoc Thanh on 4/9/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import Foundation
import Realm

public extension Subscriber {
    func depends(on supervisor: Supervisor) {
        supervisor.tokens.append(self)
    }
}

public struct Subscriber {
    internal var token: Realm.RLMNotificationToken
    internal init(token: Realm.RLMNotificationToken) {
        self.token = token
    }
    
    public func invalidate() {
        self.token.invalidate()
    }
}

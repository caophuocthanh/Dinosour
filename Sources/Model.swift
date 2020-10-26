//
//  File.swift
//  
//
//  Created by Cao Phuoc Thanh on 8/27/20.
//

import Foundation
import RealmSwift

public class Model: Object {
    
    @objc public dynamic var id: String = ""
    
    public convenience init(id: String) {
        self.init()
        self.id = id
    }
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
}

public extension Model {
        
    func stored() throws {
        try RealmDB.set(self)
    }
    
    func removed() throws {
        try RealmDB.remove(self)
    }
    
    func isExisted() -> Bool {
        let model = RealmDB.get(id)
        return model?.id == self.id
    }
    
}

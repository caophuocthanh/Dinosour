import RealmSwift
import Realm
import Foundation

public class RealmDB {
    
    public enum SetType: Int {
        case error = 1
        case modified = 3
        case all = 2
    }
    
    /// new realm
    internal static let queue: DispatchQueue = DispatchQueue(label: "RealmDB",
                                                             qos: .default,
                                                             attributes: [],
                                                             autoreleaseFrequency: .inherit,
                                                             target: nil)
    
    internal static var url: URL {
       let documentDirectory = try! FileManager.default.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false)
       let url = documentDirectory.appendingPathComponent("database.realm")
        return url
    }
    
    internal static let config: Realm.Configuration = Realm.Configuration(
        fileURL: RealmDB.url,
        readOnly: true
    )
    
    internal static let realm: Realm = try! Realm()
    
    /**
     Add object(ZModel) to store
     
     - parameter model: object (ZModel)
     */
    public static func set(_ model: Model, update: RealmDB.SetType = .modified) throws {
        try write {
            realm.add(model, update: .all)
        }
    }
    
    public static func set(_ models: [Model], update: RealmDB.SetType = .all) throws {
        try write {
            for model in models {
                realm.add(model, update: .all)
            }
        }
    }
    
    /**
     Get all object with object type
     
     - parameter type: Object Type
     
     - returns: List Model Result (ZModel)
     */
    public static func get<T: Model>() -> [T] {
        return realm.objects(T.self).map{$0}.compactMap{$0}
    }
    
    /**
     Get object with id (primary key)
     
     - parameter type: Object type
     - parameter id:   id (primary key)
     
     - returns: Object (ZModel)
     */
    public static func get<T: Model>(_ id: String) -> T? {
        if let model:T = realm.objects(T.self).filter("id = '\(id)'").first {
            return  model
        }
        return nil
    }
    
    /**
     Change value of object in block
     
     - parameter block: block()
     
     - throws:
     */
    internal static func write(_ block: (() throws -> Void)) throws {
        realm.beginWrite()
        try block()
        try realm.commitWrite()
    }
    
    /**
     Delete object (ZModel)
     
     - parameter model: object (ZModel)
     */
    public static func remove(_ model: Model)  throws {
        try realm.write {
            realm.delete(model)
        }
    }
    
}


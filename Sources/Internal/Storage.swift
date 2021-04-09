import RealmSwift
import Realm
import Foundation

internal var database: Storage {
    return Storage.default
}

internal protocol StorageProtocol {
    
    // MARK: Properties
    var url: URL {get}
    var name: String {get}
    var queue: DispatchQueue {get}
    
    // MARK: init
    init(name: String)
    
    // MARK: Methods
    func insert<T: Object>(type: T.Type, value: Object, update: Storage.SetType) throws
    func delete(_ model: Object) throws
    
    func write(block: @escaping (() throws -> Void)) throws
    
    func find<T: Object>(id: Int) -> T?
    func find<T: Object>() -> [T]
    
    func filter<Value: Equatable, T: Object, E: Any>(
        by keyPath: KeyPath<T, Value>,
        equal compareValue: E) -> Many<T>
    
    func filter<Value: Equatable, T: Object, E: Any>(
        by keyPath: KeyPath<T, Value>,
        operator basicOperator: Operator,
        to compareValue: E) -> Many<T>
    
    func filter<Value: Equatable, T: Object>(
        by keyPath: KeyPath<T, Value>,
        in strings: [String]) -> Many<T>
    
    func filter<T: Object>(query string: String) -> Many<T>
}

internal class Storage: StorageProtocol {

    class StorageProvider {
        
        static var shared: StorageProvider = StorageProvider()
        
        init() {
            self.stores = [:]
        }
        
        @Atomic var stores: [Thread: Storage] = [:]
        
        var store: Storage {
            if let _store = self.stores[Thread.current] { return _store }
            let store = Storage()
            self.stores[Thread.current] = store
            return store
        }
        
    }

    internal typealias Element = Object

    internal static var `default`: Storage {
        return StorageProvider.shared.store
    }
    
    internal let realm: Realm
    internal let config: Realm.Configuration
    internal let queue: DispatchQueue
    
    internal var url: URL
    internal var name: String
    
    internal enum SetType: Int {
        case error = 1
        case modified = 3
        case all = 2
    }
    
    required public init(name: String = "default") {
        
        let _queue = DispatchQueue(label: "Storage_\(name)")

        let _url: URL = {
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory,
                                                                 in: .userDomainMask,
                                                                 appropriateFor: nil,
                                                                 create: false)
            let url = documentDirectory.appendingPathComponent("\(name).realm")
            return url
        }()
        
        
        let _config = Realm.Configuration(
            fileURL: _url,
            readOnly: false
        )

        var _realm: Realm? = nil
        _realm = _queue.sync {
            return try? Realm(configuration: _config)
        }
        
        if _realm == nil {
            fatalError("Can not init storage")
        }
        
        self.name = name
        self.queue = _queue
        self.url = _url
        self.config = _config
        self.realm = _realm!
    }

    /**
     Change value of object in block

     - parameter block: block()

     - throws:
     */
    internal func write(block: @escaping (() throws -> Void)) throws {
        self.realm.beginWrite()
        try block()
        try! self.realm.commitWrite()
    }
}


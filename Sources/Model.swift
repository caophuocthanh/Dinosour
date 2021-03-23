//
//  File.swift
//  
//
//  Created by Cao Phuoc Thanh on 8/27/20.
//

import Foundation
import RealmSwift
import Realm


public extension Model {
    
    typealias NotificationToken = RLMNotificationToken
    
    enum ModelChange<T: Model> {
        case initial(T)
        case update(T)
        case delete
        case error(Error)
    }
}



open class Model: RealmSwift.Object, ObjectKeyIdentifiable {
    
    @objc dynamic public var id: Int = 0
    @objc dynamic public var _created_at: Double = Date().timeIntervalSince1970
    @objc dynamic public var _updated_at: Double = Date().timeIntervalSince1970
    
    internal var _uid: Int = 0
    internal var _thread: Thread = Thread.current
    
    
    public var this: Self? {
        guard self._thread == Thread.current else {
            return database.find(id: self._uid)
        }
        return self
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        super.init()
        self.id = 0
        self._uid = 0
        self._thread = Thread.current
    }
    
    public required init(id: Int) {
        super.init()
        self.id = id
        self._uid = id
        self._thread = Thread.current
    }
        
    public func observe<T: Model>(on queue: DispatchQueue? = nil,_ calback: @escaping Model.ObservableCalback<T>) -> Observable<T> {
        return Observable(T.self, queue: queue, id: self._uid, calback: calback)
    }
    
    public func write(block: @escaping (() throws -> Void)) throws {
        try database.write { try block() }
    }
    
    public func insert() throws {
        try database.insert(type: Self.self, value: self)
    }
    
    public func delete() throws {
        if self._thread != Thread.current {
            if let model: Self = database.find(id: self._uid) {
                try model.delete()
            } else {
                print("delete nil", Self.self, self._uid)
            }
        } else {
            try database.delete(self)
        }
    }
    
    public func isExisted() -> Bool {
        return database.find(id: self._uid) != nil
    }
    
    public static func find(id: Int) -> Self? {
        if let model: Self = database.find(id: id) {
            model._uid = model.id
            model._thread = Thread.current
            return model
        }
        return nil
    }
    
    public static func find<T: Model>() -> [T] {
        let result: [T] = database.find()
        for model in result {
            model._uid = model.id
            model._thread = Thread.current
        }
        return result
    }
    
    public static func filter<Value: Equatable, T: Model, E: Any>(
        by keyPath: KeyPath<T, Value>,
        equal compareValue: E) -> List<T> {
        return database.filter(by: keyPath, operator: .equal, to: compareValue)
    }
    
    public static func filter<Value: Equatable, T: Model, E: Any>(
        by keyPath: KeyPath<T, Value>,
        operator basicOperator: BasicOperator,
        to compareValue: E) -> List<T> {
        return database.filter(by: keyPath, operator: basicOperator, to: compareValue)
    }
    
    public static func filter<Value: Equatable, T: Model>(
        by keyPath: KeyPath<T, Value>,
        in strings: [String]) -> List<T> {
        return database.filter(by: keyPath, in: strings)
    }
    
}


public extension Model {
    
    typealias ObservableCalback<T: Model> = (Model.ModelChange<T>) -> Void
    
    class Observable<T: Model> {
        
        private let _error: Error = NSError(domain: "observe error", code: 1, userInfo: nil)
        
        private var token: Model.NotificationToken?
        private var threadPool: ReleasepoolThread? = nil
        
        init(_ type: T.Type, queue: DispatchQueue? = nil, id: Int,  calback: @escaping ObservableCalback<T>) {
            self.threadPool = ReleasepoolThread(name: "observe")
            self.threadPool?.runLoopPerformBlock {
                let result = database.realm.objects(type).filter("id == \(id)")
                self.token = result.observe { (changes) in
                    switch changes {
                    case .initial(let result):
                        if let model = result.last {
                            if let queue = queue {
                                let ref = ThreadSafeReference(to: model)
                                queue.async {
                                    if let o = database.realm.resolve(ref) {
                                        calback(Model.ModelChange.initial(o))
                                    } else {
                                        calback(Model.ModelChange.error(self._error))
                                    }
                                }
                            } else {
                                calback(Model.ModelChange.initial(model))
                            }
                        }
                    case .update(let result, deletions: let deletions, insertions: _, modifications: let modifications):
                        if deletions.count > 0 {
                            if let queue = queue {
                                queue.async {
                                    calback(Model.ModelChange.delete)
                                }
                            } else {
                                calback(Model.ModelChange.delete)
                            }
                        } else if modifications.count > 0 {
                            if let model = result.last {
                                if let queue = queue {
                                    let ref = ThreadSafeReference(to: model)
                                    queue.async {
                                        if let o = database.realm.resolve(ref) {
                                            calback(Model.ModelChange.update(o))
                                        } else {
                                            calback(Model.ModelChange.error(self._error))
                                        }
                                    }
                                } else {
                                    calback(Model.ModelChange.update(model))
                                }
                            }
                        }
                    case .error(let error):
                        if let queue = queue {
                            queue.async {
                                calback(Model.ModelChange.error(error))
                            }
                        } else {
                            calback(Model.ModelChange.error(error))
                        }
                    }
                }
            }
        }
        
        deinit {
            print(self, "deinit")
            self.token?.invalidate()
            self.token = nil
        }
    }
}

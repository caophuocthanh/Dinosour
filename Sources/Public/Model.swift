//
//  File.swift
//  
//
//  Created by Cao Phuoc Thanh on 8/27/20.
//

import Foundation
import RealmSwift
import Realm


public class NotificationTokenBag {
    
    public init() {}
    
    deinit {
        print("NotificationTokenBag deinit")
    }
    
    internal var tokens: [NotificationToken] = [] {
        didSet{
            print(self, "add token", tokens.count)
        }
    }
}

public extension NotificationToken {
    func disposed(by disposed: NotificationTokenBag) {
        disposed.tokens.append(self)
    }
}

public extension Model {
    
    typealias NotificationToken = RLMNotificationToken
    typealias PropertyChange = (name: String, oldValue: Any?, newValue: Any?)
    typealias ObservableCalback<T: Model> = (Model.ModelChange<T>) -> Void
    
    enum ModelChange<T: Model> {
        case initial(T)
        case update(T, [PropertyChange])
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
        print(Self.self, "init")
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
    
    deinit {
        print(Self.self, "deinit")
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

    public func observe<T: Model>(on queue: DispatchQueue? = nil,_ calback: @escaping Model.ObservableCalback<T>)-> NotificationToken? {
        guard let model: T = database.find(id: self._uid) else { return nil }
        return model.observe(on: queue) { (change: ObjectChange<T>) in
            switch change {
            case .change(let model, let properties):
                calback(Model.ModelChange<T>.update(model, properties.map { ($0.name, $0.oldValue, $0.newValue) }))
            case .deleted:
                calback(Model.ModelChange<T>.delete)
            case .error(let error):
                calback(Model.ModelChange<T>.error(error))
            }
        }
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
    
    func filter<T: Model>(query string: String) -> List<T> {
        return database.filter(query: string)
    }
}

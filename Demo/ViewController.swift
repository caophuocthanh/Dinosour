//
//  ViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 8/31/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import Storage

class Person: Model {
    
    @objc dynamic var name: String = ""
    
    required init(id: Int) {
        super.init(id: id)
    }
    
    required init(id: Int, name: String) {
        super.init(id: id)
        self.name = name
    }
}

class ViewController: UIViewController {
    
    
    let button: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("BACK", for: .normal)
        return button
    }()
    
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .red
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    @objc func tap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var bag: Model.Observable<Person>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let create: Person = Person(id: 10, name: "Person_100000")
        
        self.bag = create.observe(on: DispatchQueue.main) { (change) in
            switch change {
            case .initial(let person):
                print("notify initial:", Thread.current.name ?? "unknow", person.name)
            case .update(let person):
                print("notify update:", Thread.current.name ?? "unknow", person.name)
            case .delete:
                print("notify delete:", Thread.current.name ?? "unknow")
            case .error(let error):
                print("error", error)
            }
            
        }
        
        try! create.insert()
        
        DispatchQueue(label: "a").async {
            for i in 0...10 {
                sleep(2)
                try? create.write {
                    print("write")
                    create.this?.name = "aaaaa🦴 \(i)"
                }
            }
            
            sleep(2)
            DispatchQueue(label: "aaaaa").async {
            try? create.delete()
            }
        }
        
//        for i in 800...900 {
//            DispatchQueue(label: "c").async {
//                try? create.write {
//                    create.this?.name = "🍉(\(i)"
//                }
//            }
//        }
        
//        create100Person()
//
//
//        if let person: Person = Person.get(10) {
//            subcriblePersonAt(queue: DispatchQueue(label: "subcriblePersonAt"), person: person)
//            updateModel(queue: DispatchQueue(label: "getPersonAt"), person: person, time: 100)
//        }
    }
    
    deinit {
        print(self," deinit")
    }
}


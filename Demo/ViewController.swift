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
    
    var bag: NotificationTokenBag = NotificationTokenBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // new an object Person at main thread
        
        let perons: List<Person> = Person.filter(by: \.id, operator: .greater, to: 0)
        perons.subscribe(on:  DispatchQueue(label: "AASASAS")) { (chane) in
            print("KJKKKKKKKKKK:", chane)
        }.disposed(by: self.bag)
        

      let create: Person = Person(id: 10, name: "person")
        
        
        
        print("JHSAGFKHJSF:", create.dictionary)
        
        try! create.insert()
        
        // listen change at other thread E1
        DispatchQueue(label: "E1").asyncAfter(deadline: .now() + 1) {
            print("observe")
            create.subscribe(on: DispatchQueue.main) { (_, change: Model.ModelChange<Person>) in
                switch change {
                case .initial(let person):
                    print("notify initial:", Thread.current.name ?? "unknow", person.name)
                case .update(let person, let properties):
                    print("notify update:", Thread.current.name ?? "unknow", person.name, properties)
                case .delete:
                    print("notify delete:", Thread.current.name ?? "unknow")
                case .error(let error):
                    print("error", error)
                }
            }?.disposed(by: self.bag)
        }
        
        // read object at other thread E12222. use this to access safe properties
        DispatchQueue(label: "E21").asyncAfter(deadline: .now() + 5) {
            print("get")
            DispatchQueue.main.async {
                if let per = Person.find(id: 10) {
                    DispatchQueue(label: "E12222").async {
                        print("object:", per.this?.name)
                    }
                } else {
                    print("get nil")
                }
            }
        }
        
        // upadte object at other thread E3
        DispatchQueue(label: "E3").asyncAfter(deadline: .now() + 7) {
            print("write")
            for i in 0...10 {
                //sleep(1)
                try? create.write {
                    print("write")
                    create.this?.name = "person🦴 \(i)"
                }
            }
            
//
//            // delete object at other thread E4
//            sleep(2)
//            DispatchQueue(label: "E4").asyncAfter(deadline: .now() + 1) {
//                print("delete")
//                try? create.delete()
//            }
        }
    }
    
    deinit {
        print(self," deinit")
    }
}


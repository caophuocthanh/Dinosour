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
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .red
    }
    
    var bag: ModelOnChange<Person>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let create: Person = Person(id: 10, name: "KSJGFLKHJSGF")
        try! create.save()
        
        let abc: Person? = Person.object(10)

        abc?.changed { (e: Person?, c) in
            print("🍎🍎🍎🍎🍎: change", c, e?.name)
        }

        sleep(1)
        
        DispatchQueue.global().async {

            if let model: Person = Person.object(10) {

                print("model:", model.id, model.id)
                print("AAAA:", Thread.current)
                
                sleep(1)
                
                for i in 0...10 {
                    sleep(1)
                    try? model.write {
                        model.name = "10000_\(i)"
                    }
                    try? model.save()
                }
                
                print("modelaa:", model.id)
                try? model.delete()
                
            } else {
                print("can not find")
            }
            
        }
        
        //        if let amodel: Model = Storage.default.object(id: "allo") {
        ////            amodel.observe { (o, changes) in
        ////                print("_model:", o?.id, changes)
        ////            }
        //        }
    }
    
    
}


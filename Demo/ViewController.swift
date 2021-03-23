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
        
        
        let create: Person = Person(id: 10, name: "person")
        
        DispatchQueue(label: "E1").sync {
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
        }
        
        DispatchQueue(label: "E2").sync {
            try! create.insert()
        }
        
        DispatchQueue(label: "E3").async {
            for i in 0...10 {
                sleep(2)
                try? create.write {
                    print("write")
                    create.this?.name = "person🦴 \(i)"
                }
            }
            
            sleep(2)
            DispatchQueue(label: "E4").async {
                try? create.delete()
            }
        }
    }
    
    deinit {
        print(self," deinit")
    }
}


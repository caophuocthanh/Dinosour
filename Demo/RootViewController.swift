//
//  RootViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 3/22/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import Storage

class RootViewController: UIViewController {

    let button: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .red
        button.setTitle("BACK", for: .normal)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
//        DispatchQueue(label: "E1").async {
//            Person.find(id: 10)?.subscribe(on: DispatchQueue.main) { (_, change: Model.ObjectChange<Person>) in
//                switch change {
//                case .initial(let person):
//                    print("notify initial:", Thread.current.name ?? "unknow", person.name)
//                case .update(let person, let properties):
//                    print("notify update:", Thread.current.name ?? "unknow", person.name, properties)
//                case .delete:
//                    print("notify delete:", Thread.current.name ?? "unknow")
//                case .error(let error):
//                    print("error", error)
//                }
//            }?.disposed(by: self.bag)
//        }
        
    }
    
    var bag: Supervisor = Supervisor()
    
    @objc func tap() {

        DispatchQueue(label: "E3").asyncAfter(deadline: .now()) {
            print("write")
            
            if let create: Person = Person.find(id: 10) {
                
                for i in 0...10 {
                    //sleep(1)
                    try? create.write {
                        print("write")
                        create.this?.name = "person🦴"
                    }
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.pushViewController(ViewController(), animated: true)
        // Do any additional setup after loading the view.
    }

}

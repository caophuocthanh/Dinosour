//
//  RootViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 3/22/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

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
    }
    
    @objc func tap() {

        DispatchQueue(label: "E3").asyncAfter(deadline: .now()) {
            print("write")
            
            let create: Person = Person(id: 10, name: "person")
            
            for i in 0...10 {
                //sleep(1)
                try? create.write {
                    print("write")
                    create.this?.name = "person🦴 \(i)"
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

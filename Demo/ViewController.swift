//
//  ViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 8/31/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import DataMine

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let model: Model = Model(id: "allo")
        try? RealmDB.set(model)
        let amodel: Model? = RealmDB.get("allo")
        print("model:", model.id)
        print("amodel:", amodel?.id)
    }


}


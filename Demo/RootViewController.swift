//
//  RootViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 3/22/21.
//  Copyright © 2021 Cao Phuoc Thanh. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.pushViewController(ViewController(), animated: true)
        // Do any additional setup after loading the view.
    }

}

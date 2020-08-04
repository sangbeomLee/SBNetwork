//
//  ViewController.swift
//  SBNetwork
//
//  Created by sangbeomLee on 08/04/2020.
//  Copyright (c) 2020 sangbeomLee. All rights reserved.
//

import UIKit
import SBNetwork

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SBNetwork().log(with: "HELLO")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


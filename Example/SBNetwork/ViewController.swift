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
    @IBOutlet weak var testImageView: UIImageView!
    let url = URL(string: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")!
    
    // Networking model, real model 두개를 만든다.
    override func viewDidLoad() {
        super.viewDidLoad()
        testImageView.backgroundColor = .black
        testImageView.setImage(from: url, showsIndicator: true)
    }
    
    @IBAction func refreshButtonDidTapped(_ sender: UIButton) {
        testImageView.setImage(from: url)
    }
}

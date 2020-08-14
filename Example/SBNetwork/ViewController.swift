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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")!
        SBImageManager.shared.fetch(url) { (result) in
            switch result {
            case .success(let image):
                self.testImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


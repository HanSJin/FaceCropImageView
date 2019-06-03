//
//  ViewController.swift
//  FaceCropImageView
//
//  Created by hansjin on 06/03/2019.
//  Copyright (c) 2019 hansjin. All rights reserved.
//

import UIKit
import FaceCropImageView

class ExampleViewController: UIViewController {

    @IBOutlet weak var normalImageView: UIImageView!
    @IBOutlet weak var faceCropImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        normalImageView.contentMode = .scaleAspectFill
        normalImageView.image = UIImage(named: "jenny12")
        
//        faceCropImageView.setFaceImge(UIImage(named: "jenny12"), completion: { result in
//        
//        })
        
    }
}


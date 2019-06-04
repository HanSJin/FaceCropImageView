//
//  ViewController.swift
//  FaceCropImageView
//
//  Created by hansjin on 06/03/2019.
//  Copyright (c) 2019 hansjin. All rights reserved.
//

import UIKit
import FaceCropImageView
import Kingfisher

class ExampleViewController: UIViewController {
    
    // Outlets
    @IBOutlet var normalImageViews: [UIImageView]!
    @IBOutlet var faceCropImageViews: [UIImageView]!
    
    // Variables
    let imageUrls: [String] = [
        "https://cdn.pixabay.com/photo/2018/04/10/12/54/girl-3307264_1280.jpg",
        "https://cdn.pixabay.com/photo/2017/09/16/14/33/electrician-2755684_1280.jpg",
        "https://cdn.pixabay.com/photo/2019/05/30/20/48/couple-4240713_1280.jpg",
        "https://cdn.pixabay.com/photo/2017/08/03/17/36/model-2577543_1280.jpg",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0..<imageUrls.count {
            let imageUrl = URL(string: imageUrls[index])
                
            // Set the normal image.
            normalImageViews[index].kf.setImage(with: imageUrl)
            
            // Set the face crop image.
            faceCropImageViews[index].setFaceImage(with: imageUrl)
        }
    }
}


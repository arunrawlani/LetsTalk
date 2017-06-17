//
//  PictureViewController.swift
//  LetsTalk
//
//  Created by Arun Rawlani on 6/17/17.
//  Copyright © 2017 Arun Rawlani. All rights reserved.
//

import Foundation
import UIKit

class PictureViewController: UIViewController{
    var names: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "1")!,
        UIImage(named: "2")!
    ]
    @IBOutlet weak var pictureBox: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
    
    var pictureCount = 0;
    
    override func viewDidLoad() {
        pictureCount = 0;
    }
    
    
    @IBAction func nextPicture(_ sender: Any) {
        
        //changes picture in the box
        pictureCount += 1
        if (pictureCount >= names.count){
            pictureCount = 0
        }
        pictureBox.image = names[pictureCount]
    }
    
}

//
//  PictureViewController.swift
//  LetsTalk
//
//  Created by Arun Rawlani on 6/17/17.
//  Copyright © 2017 Arun Rawlani. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PictureViewController: UIViewController{
    var names: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!,
        UIImage(named: "9")!,
        UIImage(named: "10")!,
        UIImage(named: "11")!,
        UIImage(named: "12")!
    ]
    @IBOutlet weak var pictureBox: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var pictureCount = 0
    
    override func viewDidLoad() {
        pictureCount = 0
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

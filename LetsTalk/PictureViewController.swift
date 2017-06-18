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
import Alamofire

class PictureViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var previousAudioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var audioFilename: URL!
    var pictureCount = 0
    
    override func viewDidLoad() {
        pictureCount = 0
        changeButton.isHidden = true;
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        playButton.isEnabled = false
        recordTapped()
    }

    @IBAction func playPressed(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: previousAudioRecorder.url)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
            audioPlayer.volume = 1.0
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func nextPicture(_ sender: Any) {
        
        //changes picture in the box
        changeButton.isHidden = true;
        pictureCount += 1
        if (pictureCount >= names.count){
            pictureCount = 0
        }
        pictureBox.image = names[pictureCount]
    }
    
    //HELPER METHODS FOR RECORDING AUDIO
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
            playButton.isHidden = false
            changeButton.isHidden = false;
            
            //sending the recording to the backend
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(self.previousAudioRecorder.url, withName: "file")
            },
                to: "http://ec2-13-58-233-169.us-east-2.compute.amazonaws.com:17001/raw_audio",
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
            )
            
        }
    }
    
    func startRecording(){
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        print(audioFilename)
        let settings = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM),
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:1,
            AVLinearPCMBitDepthKey:8,
            AVLinearPCMIsFloatKey:false,
            AVLinearPCMIsBigEndianKey:false,
            AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue
        ] as [String : Any]
        
        //            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        //            AVSampleRateKey: 12000,
        //            AVNumberOfChannelsKey: 1,
        //            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        previousAudioRecorder = audioRecorder
        audioRecorder = nil
        
        if success {
            recordButton.isHidden = true;
            //recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}

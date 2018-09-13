//
//  ViewController.swift
//  AVPlayer
//
//  Created by liushungxi on 2018/9/6.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var synthesizer = AVSpeechSynthesizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(imageview)
        imageview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

//        let str = "Call can throw, but it is not marked with 'try' and the error is not handled"
//        let utterance = AVSpeechUtterance(string: str)
//        utterance.rate = 0.2
//
//        synthesizer.speak(utterance)
        //暂停
//        synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
        //停止
//        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
        let pick = UIImagePickerController()
        let sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        pick.sourceType = sourceType
        pick.delegate = self
        self.present(pick, animated: true, completion: nil)
        
    
    }
    var imageview = UIImageView()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageview.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


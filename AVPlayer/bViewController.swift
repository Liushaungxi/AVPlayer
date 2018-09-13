//
//  bViewController.swift
//  AVPlayer
//
//  Created by liushungxi on 2018/9/7.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit

class bViewController: UIImagePickerController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegate = self
        //有摄像头
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageview: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageview.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

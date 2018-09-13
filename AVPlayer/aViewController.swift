//
//  aViewController.swift
//  AVPlayer
//
//  Created by liushungxi on 2018/9/6.
//  Copyright © 2018年 liushungxi. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
class aViewController: UIViewController {

    var player:AVPlayer?
    var playeritem:AVPlayerItem?
    var link:CADisplayLink!
    var playerLayer:AVPlayerLayer!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var videoBox: UIView!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoBoxWeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //单击事件必须在双击事件检测失败后才执行
        singleTouch.require(toFail: doubleTouch)
        
        //16:9
        videoHeight.constant = UIScreen.main.bounds.width * 9 / 16
        
        //计时器 正常情况下每秒60帧
        link = CADisplayLink(target: self, selector: #selector(updata))
        link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        // 创建视频资源
        let contentUrl = URL(fileURLWithPath: "/Users/liushungxi/Desktop/音乐播放器1.mp4")
        let url = URL.init(string: "http://192.168.1.220:8080/u/201806/1410355574rc.mp4")!
        playeritem = AVPlayerItem(url: contentUrl)
        // 监听状态改变
        playeritem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        // 将视频资源赋值给视频播放对象
        player = AVPlayer(playerItem: playeritem)
        // 初始化视频显示layer
        playerLayer = AVPlayerLayer(player: player)
        // 设置显示模式
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//        playerLayer.contentsScale = UIScreen.main.scale
        videoBox.layer.addSublayer(playerLayer)
        playerLayer.frame = videoBox.bounds
        // 位置放在最底下
        videoBox.layer.insertSublayer(playerLayer, at: 0)
        
        //按下
        slider.addTarget(self, action: #selector(sliderTouchDown( _:)), for: .touchDown)
        //谈起
        slider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut( _:)), for: .touchCancel)
        // Do any additional setup after loading the view.
    }
    
    var slidering = false
    @objc func sliderTouchUpOut(_ slider:UISlider){
        //当播放正常的时候才能滑动slider
        if player?.status == AVPlayerStatus.readyToPlay{
            let duration = slider.value * Float(TimeInterval((playeritem?.duration.value)!) / TimeInterval((playeritem?.duration.timescale)!))
            let seekTime = CMTimeMake(Int64(duration), 1)
            player?.seek(to: seekTime, completionHandler: { (_) in
                self.slidering = false
            })
        }
    }
    @objc func sliderTouchDown(_ slider:UISlider){
        slidering = true
    }
    @objc func updata(){
        //当前时间
        let currentTime = CMTimeGetSeconds((self.player?.currentTime())!)
        //总时间
        let totalTime = TimeInterval((playeritem?.duration.value)!) / TimeInterval((playeritem?.duration.timescale)!)
        
        totalTimeLabel.text = formatPlayTime(secounds: totalTime)
        currentTimeLabel.text = formatPlayTime(secounds: currentTime)
        //slider滑动时不更新slider
        if !slidering{
            slider.value = Float(currentTime/totalTime)
        }
    }
    //控件
    //播放暂停
    @IBOutlet weak var playButton: UIButton!
    @IBAction func play(_ sender: UIButton) {
        if !sender.isSelected {
            player?.pause()
        }else{
            if player?.status == AVPlayerStatus.readyToPlay{
                player?.play()
            }
        }
        sender.isSelected = !sender.isSelected
    }
    //全屏
    var isFullScreen = false
    var isleft = false
    @IBAction func fullScreen(_ sender: UIButton) {
        if !isFullScreen{
            //强制横屏
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            videoBox.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            playerLayer.frame = UIScreen.main.bounds
            isFullScreen = true
        }
        else{
            //强制横屏以及判断是否是横屏后再次点击横屏键
            if isleft{
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                isleft = false
            }else{
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                isleft = true
            }
        }
    }
    //返回键
    @IBAction func back(_ sender: UIButton) {
        if !isFullScreen {
            self.navigationController?.popViewController(animated: true)
        }else{
            //强制竖屏并且重新设置视图的Frame以及playerlayer的Frame
            isFullScreen = false
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            videoBox.snp.removeConstraints()
            videoBox.snp.makeConstraints { (make) in
                make.top.equalTo(44)
                make.left.right.equalToSuperview()
                videoBox.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9 / 16)
            }
            playerLayer.frame = videoBox.bounds
        }
    }
    //下边边视图
    @IBOutlet weak var bottonView: UIView!
    //上边视图
    @IBOutlet weak var topView: UIView!
    //视频title
    @IBOutlet weak var titleLabel: UILabel!
    //时间进度
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    //单击事件
    @IBOutlet var singleTouch: UITapGestureRecognizer!
    @IBAction func singleTouch(_ sender: UITapGestureRecognizer) {
        topView.isHidden = !topView.isHidden
        bottonView.isHidden = !bottonView.isHidden
    }
    //双击
    @IBOutlet var doubleTouch: UITapGestureRecognizer!
    @IBAction func doubleTouch(_ sender: Any) {
        playButton.sendActions(for: .touchUpInside)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status"{
            if playeritem?.status == AVPlayerItemStatus.readyToPlay{
                self.player?.play()
            }else{
                print("加载异常")
            }
        }
    }
    //移除监听
    deinit {
        playeritem?.removeObserver(self, forKeyPath: "status")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //时间转换成秒
    func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }

}

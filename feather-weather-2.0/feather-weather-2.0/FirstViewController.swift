//
//  FirstViewController.swift
//  feather-weather-2.0
//
//  Created by IO on 24/08/2019.
//  Copyright © 2019 Mukh LTD. All rights reserved.
//

import UIKit
import AVFoundation


class FirstViewController: UIViewController {

    var player: AVPlayer?
    
    override func viewDidLoad() {
        backgroundRain()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func backgroundRain() {
        let path = Bundle.main.path(forResource: "rain.mp4", ofType: nil)
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    
    @objc func playerItemDidReachEnd() {
        player!.seek(to: CMTime.zero)
    }

}


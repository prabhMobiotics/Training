//
//  Player.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 11/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVFoundation
import AVKit

class Player: PlayVideo {
    
    var avPlayer = AVPlayer()
    var avPlayerVc = AVPlayerViewController()
    
    func playVideo(url: String, handler: @escaping(AVPlayerViewController)->Void) {
        guard let url = URL(string: url) else {return}
        avPlayer = AVPlayer(url: url)
        avPlayer.actionAtItemEnd = .none
        avPlayerVc = AVPlayerViewController()
        avPlayerVc.player = avPlayer
        handler(avPlayerVc)
    }
    
}

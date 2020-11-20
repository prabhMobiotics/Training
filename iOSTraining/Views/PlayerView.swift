//
//  PlayerView.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 12/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVFoundation
import UIKit

class VideoPlayer: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
}

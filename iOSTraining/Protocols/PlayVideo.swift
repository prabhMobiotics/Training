//
//  PlayVideo.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 11/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVKit

protocol PlayVideo {
    func playVideo(url: String, handler: @escaping(AVPlayerViewController)->Void)
}

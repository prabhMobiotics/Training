//
//  CustomPlayerView.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 12/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVFoundation
import UIKit

class CustomPlayerView: UIView {
    
    //MARK: Properties
    let videoPlayerView = VideoPlayer()
    private let player = AVQueuePlayer()
    
    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initialisePlayer()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: ViewSetup
    private func setupViews() {
        print("Set up Views Ran")
        addSubview(videoPlayerView)
    }
    //MARK: Tried constraints but layout is not working as expected. Needed to give bounds to avplayerlayer of videoplayer
    
    //    private func setUpConstraints() {
    //        let safeAreaGuide = self.safeAreaLayoutGuide
    //        NSLayoutConstraint.activate([
    //            videoPlayerView.topAnchor.constraint(equalTo: self.topAnchor),
    //            videoPlayerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
    //            videoPlayerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    //            videoPlayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    //        ])
    //    }
    
    //Adding player view inside initialiser does not display video. needed to set frames here to get the video to display.
    //MARK: LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Layout subviews Ran")
        videoPlayerView.frame = bounds
        print("Frame \(videoPlayerView.frame)")
        print("Bounds \(bounds)")
        //addSubview(videoPlayerView)
    }
    
    //MARK: Methods
    private func initialisePlayer() {
        videoPlayerView.player = player
        videoPlayerView.playerLayer.frame = bounds
        videoPlayerView.playerLayer.videoGravity = .resize
        addItemsToPlayer()
        play()

    }
    
    private func addItemsToPlayer() {
        guard let url = URL(string: Constants.urlB) else {return}
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player.insert(item, after: player.items().last)
    }
    
    private func setUpStatusObserver() {
        
    }
    
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
}

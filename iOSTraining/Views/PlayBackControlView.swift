//
//  PlayBackControlView.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 13/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVFoundation
import UIKit

class PlayBackControlView: UIView {
    
    //MARK: Properties
    var player: AVPlayer?
    
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    lazy var playBackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var playButtonView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.pauseIcon)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var fastForwardView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.fastForward)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var rewindView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.castBackward)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: View SetUP
    private func setupViews() {
        backgroundColor = .gray
        alpha = 0.7
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playBackStackView)
        playBackStackView.addArrangedSubview(rewindView)
        playBackStackView.addArrangedSubview(playButtonView)
        playBackStackView.addArrangedSubview(fastForwardView)
    }
    
    //MARK: Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            playBackStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playBackStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            playButtonView.heightAnchor.constraint(equalToConstant: 20),
            playButtonView.widthAnchor.constraint(equalToConstant: 20),
            
            rewindView.heightAnchor.constraint(equalToConstant: 20),
            rewindView.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    //MARK: Gestures
    private func setupGestures() {
        let playTap = UITapGestureRecognizer(target: self, action: #selector(playAndPause))
        playButtonView.addGestureRecognizer(playTap)
        let forwardTap = UITapGestureRecognizer(target: self, action: #selector(seekTo))
        fastForwardView.addGestureRecognizer(forwardTap)
        let rewindTap = UITapGestureRecognizer(target: self, action: #selector(rewind))
        rewindView.addGestureRecognizer(rewindTap)
        
    }
    
    //MARK: Playback Methods
    @objc func playAndPause() {
        if isPlaying {
            player?.pause()
            playButtonView.image = UIImage(named: Constants.playIcon)
        } else {
            player?.play()
            playButtonView.image = UIImage(named: Constants.pauseIcon)
        }
        
    }
    
    @objc func rewind() {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - 5
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @objc func seekTo() {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            
            var newTime = CMTimeGetSeconds(currentTime) + 5
            
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
}

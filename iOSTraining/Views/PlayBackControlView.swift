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
    var player: AVPlayer? {
        didSet {
            if player != nil {setupObservers()}
        }
    }
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    //var playStatus: Box<AVPlayer.Status?>?
    var statusToken: NSKeyValueObservation?
    var valueToken: NSKeyValueObservation?
    var seekerObserverToken: Any?
    var timeObserverToken: Any?
    var currentTime: String = ""
    var currentDuration: String = ""
    
    lazy var playBackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
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
    
    lazy var seekBar: UISlider = {
        let slider = UISlider()
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(seekBarValueChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00 / 0:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(seekBar)
        addSubview(playBackStackView)
        playBackStackView.addArrangedSubview(rewindView)
        playBackStackView.addArrangedSubview(playButtonView)
        playBackStackView.addArrangedSubview(fastForwardView)
        playBackStackView.addArrangedSubview(currentTimeLabel)
    }
    
    //MARK: Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            seekBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            seekBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            seekBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            playBackStackView.topAnchor.constraint(equalTo: seekBar.bottomAnchor, constant: 10),
            playBackStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            playBackStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            playButtonView.heightAnchor.constraint(equalToConstant: 22),
            playButtonView.widthAnchor.constraint(equalToConstant: 22),
            
//            rewindView.heightAnchor.constraint(equalToConstant: 25),
//            rewindView.widthAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    //MARK: Observers
    private func setupObservers() {
        
        statusToken = player?.observe(\.currentItem?.status, changeHandler: { [weak self] (player, _) in
            if player.currentItem?.status == .readyToPlay {
                print("Ready to play")
                self?.setMaxSeekValue()
            }
        })
        
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.01, preferredTimescale: timeScale)
        
        seekerObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) {
            [weak self] time in
            // update player transport UI
            UIView.animate(withDuration: 0.4) { [weak self] in
                if let currentTime = self?.player?.currentItem?.currentTime() {
                    let seconds: Float64 = CMTimeGetSeconds(currentTime)
                    self?.seekBar.value = Float(seconds)
                    self?.seekBar.layoutIfNeeded()
                }
            }
            
        }
        
        setupTimeObserver()
        
    }
    
    private func setupTimeObserver() {
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
        var currentTimeText: String = ""
        
        player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { [weak self] (time) in
            if let currentTime = self?.player?.currentItem?.currentTime() {
                let seconds: Float64 = CMTimeGetSeconds(currentTime)
                print("current time is \(seconds)")
                let tuple = self?.secondsToHoursMinutesSeconds(seconds: Int(seconds))
                currentTimeText = "\(tuple!.0 == 0 ? "" : "\(tuple!.0):")\(tuple!.1):\(tuple!.2)"
                self?.currentTimeLabel.text = currentTimeText + (self?.currentDuration ?? "")
            }
        })
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
        if let currentTime = player?.currentItem?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - 5
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @objc func seekTo() {
        if let currentTime = player?.currentItem?.currentTime(), let duration = player?.currentItem?.duration {
            
            var newTime = CMTimeGetSeconds(currentTime) + 5
            
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @objc func seekBarValueChanged(_ slider: UISlider) {
        let seconds: Int64 = Int64(slider.value)
        let targetTime: CMTime = CMTime(value: seconds, timescale: 1)
        print("Seeking to \(seconds)")
        player?.seek(to: targetTime)
    }
    
    private func setMaxSeekValue() {
        if let duration = player?.currentItem?.duration {
            let seconds: Float64 = CMTimeGetSeconds(duration)
            print("Max value is \(seconds)")
            seekBar.maximumValue = Float(seconds)
            let tuple = secondsToHoursMinutesSeconds(seconds: Int(seconds))
            self.currentDuration = " / \(tuple.0 == 0 ? "" : "\(tuple.0):")\(tuple.1):\(tuple.2)"
        }
    }
    
    private func getCurrentSeconds() {
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: DeInitialisers
    deinit {
        statusToken = nil
        removePeriodicTimeObserver()
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = seekerObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.seekerObserverToken = nil
        }
    }
    
}

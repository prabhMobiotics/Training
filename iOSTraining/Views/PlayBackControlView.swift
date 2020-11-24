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
    private var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    private var statusToken: NSKeyValueObservation?
    private var valueToken: NSKeyValueObservation?
    private var seekerObserverToken: Any?
    private var timeObserverToken: Any?
    private var currentTime: String = ""
    private var currentDuration: String = ""
    private var regularConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    private var commonConstraints: [NSLayoutConstraint] = []
    //TODO: Make this height bool
    private var height: CGFloat = 1 {
        didSet {
            //self.removeFromSuperview()
            if height == 0 {
                UIView.animate(withDuration: 0.4) { [weak self] in
                    self?.subviews.forEach({ $0.removeFromSuperview() })
                    self?.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.4) { [weak self] in
                    self?.addSubViews()
                    self?.activateConstraints()
                }
                
            }
        }
    }
    
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
        setupCommonConstarints()
        setupRegularConstraints()
        setupCompactConstraints()
        setupViews()
        setupGestures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.height = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: View SetUP
    private func setupViews() {
        backgroundColor = .gray
        alpha = 0.7
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubViews()
        activateConstraints()
    }
    
    private func addSubViews(){
         self.addSubview(self.seekBar)
         self.addSubview(self.playBackStackView)
         self.playBackStackView.addArrangedSubview(self.rewindView)
         self.playBackStackView.addArrangedSubview(self.playButtonView)
         self.playBackStackView.addArrangedSubview(self.fastForwardView)
         self.playBackStackView.addArrangedSubview(self.currentTimeLabel)
    }
    
    //MARK: Constraints
    private func setupCommonConstarints() {
        commonConstraints.append(contentsOf: [
            seekBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            seekBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            seekBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            playBackStackView.topAnchor.constraint(equalTo: seekBar.bottomAnchor, constant: 10),
            playBackStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            playBackStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),

        ])
    }
    
    private func setupRegularConstraints() {
        regularConstraints.append(contentsOf: [
            playButtonView.widthAnchor.constraint(equalToConstant: 35),
            playButtonView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupCompactConstraints() {
        compactConstraints.append(contentsOf: [
            playButtonView.widthAnchor.constraint(equalToConstant: 22),
            playButtonView.heightAnchor.constraint(equalToConstant: 22 )
        ])
    }
    
    private func activateConstraints() {
        
        guard compactConstraints.count > 0, regularConstraints.count > 0, commonConstraints.count > 0 else {
            fatalError("Setup constraints before activating them")
        }
        
        NSLayoutConstraint.activate(commonConstraints)
        
        if traitCollection.horizontalSizeClass == .regular {
            if compactConstraints.first!.isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        } else {
            if regularConstraints.first!.isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        }
        
    }
    
    //MARK: Delegate methods
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        super.traitCollectionDidChange(previousTraitCollection)
        
        layoutTraits()
        
        if self.subviews.isEmpty == false {
            activateConstraints()
        }
    }
    
    private func layoutTraits() {
        if traitCollection.horizontalSizeClass == .regular {
            currentTimeLabel.font = UIFont.boldSystemFont(ofSize: 22)
        } else {
            currentTimeLabel.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
    //MARK: Observers
    private func setupObservers() {
        
        statusToken = player?.observe(\.currentItem?.status, changeHandler: { [weak self] (player, _) in
            if player.currentItem?.status == .readyToPlay {
                print("Ready to play")
                self?.setMaxSeekValue()
            }
        })
        
        setupSeekerObserver()
        setupTimeObserver()
        
    }
    
    private func setupSeekerObserver() {
        
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
    
    //MARK: Util Methods
    
    func toggleView() {
        if self.height != 0 {
            self.height = 0
        } else {
            self.height = 1
        }
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

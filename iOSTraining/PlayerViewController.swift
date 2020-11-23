//
//  PlayerViewController.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 12/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    //MARK: Properties
    lazy var customPlayer: CustomPlayerView = {
        let player = CustomPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    lazy var playBackView = PlayBackControlView()
    lazy var crossView = CrossView()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpUI()
        setUpConstraints()
        // customPlayer.play()
    }
    
    //MARK: ViewSetup
    private func setUpViews() {
        self.view.addSubview(customPlayer)
        self.view.addSubview(playBackView)
        self.view.addSubview(crossView)
        playBackView.player = customPlayer.videoPlayerView.player
        crossView.crossTapHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .brown
    }
    
    //MARK: Constraints
    private func setUpConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            customPlayer.topAnchor.constraint(equalTo: self.view.topAnchor),
            customPlayer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            customPlayer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            customPlayer.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            //            customPlayer.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.100),
            
            playBackView.bottomAnchor.constraint(equalTo: customPlayer.bottomAnchor),
            playBackView.leadingAnchor.constraint(equalTo: customPlayer.leadingAnchor),
            playBackView.trailingAnchor.constraint(equalTo: customPlayer.trailingAnchor),
//            playBackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.10),
            
            crossView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor,constant: 10),
            crossView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -10),
            crossView.widthAnchor.constraint(equalToConstant: 40),
            crossView.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
    }
    
    
    //MARK: Methods for Landscape only
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    
    
}

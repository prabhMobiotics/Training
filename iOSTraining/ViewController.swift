//
//  ViewController.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 11/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

import SuppressString

class ViewController: UIViewController {
    
    //MARK: Properties
    var player: PlayVideo?
    
    //MARK: Views
    lazy var playButton: PlayButton = {
        let button = PlayButton()
        button.addTarget(self, action: #selector(playVideos), for: .touchUpInside)
        return button
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        view.addSubview(playButton)
        setupConstraints()
        
        suppressExample()
    }
    
    //MARK: Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    //MARK: Methods
    @objc private func playVideos() {
//        player = Player()
//        player?.playVideo(url: url2) { [weak self] (playerVc) in
//            self?.present(playerVc, animated: true) {
//                playerVc.player?.play()
//            }
//        }
        
        let playerVc = PlayerViewController()
        playerVc.modalPresentationStyle = .automatic
        self.present(playerVc, animated: true, completion: nil)
    }
    
    //MARK: Supress Framework example
    private func suppressExample() {
        let suppressor = Suppress()
        let suppressedString = suppressor.compress(string: "an apple laaptopp")
        print("Suppressed String is \(suppressedString)")

        let decompressedString = suppressor.decompress(string: suppressedString)
        print("Decompressed String is \(decompressedString)")
    }
}


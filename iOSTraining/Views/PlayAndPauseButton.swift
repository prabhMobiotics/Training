//
//  PlayAndPauseButton.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 12/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import AVFoundation
import UIKit

//NOT IN USE
class PlayAndPauseButton: UIView {
    
    //MARK: Properties
    var player: AVPlayer?
    
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewSetup
    private func setupView() {
        guard let superview = superview?.safeAreaLayoutGuide else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 50),
            self.heightAnchor.constraint(equalToConstant: 50),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
        setButtonImage()
    }
    
    private func setButtonImage() {
        UIGraphicsBeginImageContext(frame.size)
        UIImage(named: Constants.playIcon)?.draw(in: bounds)
        UIGraphicsEndImageContext()
    }
    
}

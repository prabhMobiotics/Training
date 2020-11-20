//
//  CrossView.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 13/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit

class CrossView: UIView {
    
    //MARK: Properties
    lazy var crossImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.crossImage)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var crossTapHandler: (() -> Void) = {}
    
    //MARK: Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     //MARK: View SetUp
    private func setupViews() {
        addSubview(crossImage)
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        alpha = 0.8
        layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            crossImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            crossImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            crossImage.widthAnchor.constraint(equalToConstant: 20),
            crossImage.heightAnchor.constraint(equalToConstant: 20)
        ])
        setupGesture()
    }
    
    private func setupGesture() {
        let crossTap = UITapGestureRecognizer(target: self, action: #selector(crossTapAction))
        crossImage.addGestureRecognizer(crossTap)
        
    }
    
    //MARK: Actions
    @objc func crossTapAction() {
        print("cross tappedd")
        crossTapHandler()
    }
    
    
    
    
}

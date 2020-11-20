//
//  PlayButton.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 11/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit

class PlayButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("Play", for: .normal)
        setTitleColor(.blue, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

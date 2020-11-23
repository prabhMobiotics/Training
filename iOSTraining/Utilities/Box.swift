//
//  Box.swift
//  iOSTraining
//
//  Created by Prabhdeep Singh on 23/11/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

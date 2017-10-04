//
//  RoundImage.swift
//  PinApp
//
//  Created by Stefan Markovic on 10/4/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func roundImage() {
        
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}


extension UIView {
    func roundCorners() {
        layer.cornerRadius = 15
    }
}

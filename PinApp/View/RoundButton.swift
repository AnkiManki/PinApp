//
//  RoundButton.swift
//  PinApp
//
//  Created by Stefan Markovic on 10/4/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit

extension UIButton {
    
    func roundButton() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 5
    }
    
    
    
}

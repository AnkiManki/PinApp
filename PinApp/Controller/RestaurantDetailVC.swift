//
//  RestaurantDetailVC.swift
//  PinApp
//
//  Created by Stefan Markovic on 10/1/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit

class RestaurantDetailVC: UIViewController {

    @IBOutlet var restaurantImageView: UIImageView!
    var restaurantImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantImageView.image = UIImage(named: restaurantImage)

    }

 

}

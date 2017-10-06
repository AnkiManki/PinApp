//
//  RestaurantCell.swift
//  PinApp
//
//  Created by Stefan Markovic on 9/30/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    func configureCell(restaurant: RestaurantMO) {
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.location
        typeLabel.text = restaurant.type
        thumbnailImageView.image = UIImage(data: restaurant.image!)

    }
    
}


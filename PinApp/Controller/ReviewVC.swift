//
//  ReviewVC.swift
//  PinApp
//
//  Created by Stefan Markovic on 10/1/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {
    
    @IBOutlet weak var backGroundImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    var restaurant: RestaurantMO?
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect()
        
        containerView.transform = CGAffineTransform.init(translationX: 0, y: -1000)
        closeButtonOutlet.transform = CGAffineTransform.init(translationX: +1000, y: 0)
        
        if let restaurant = restaurant {
            restaurantImageView.image = UIImage(data: restaurant.image!)
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4) {
            self.closeButtonOutlet.transform = CGAffineTransform.identity
        }

    }
    

    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backGroundImgView.addSubview(blurEffectView)
    }


    
}



















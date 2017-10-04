//
//  RestaurantDetailVC.swift
//  PinApp
//
//  Created by Stefan Markovic on 10/1/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit
import MapKit

class DetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Variables
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantImageView.image = UIImage(data: restaurant.image!)
        setTableViewStyle()
        title = restaurant.name
        
        myTableView.estimatedRowHeight = 36.0
        myTableView.rowHeight = UITableViewAutomaticDimension
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGesture)
        
        addPinAnnotation()
    }
    
    //MARK: - IBAction - rating button
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            restaurant.isVisited = true
            
            switch rating {
            case "great": restaurant.rating = "Absolutely love it! Must try."
            case "good": restaurant.rating = "Pretty good."
            case "dislike": restaurant.rating = "It's not good I don't like it."
            default: break
            }
        }
        
        appDelegate.saveContext()
        myTableView.reloadData()
    }
    
    //MARK: - Table Views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before \(restaurant.rating ?? "")" : "No"
        case 4:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            
            if let phone = restaurant.phone {
                let alert = UIAlertController(title: "\(phone)", message: "Do you want to call \(restaurant.name ?? "")", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Call", style: .default, handler: nil)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - TableView design
    func setTableViewStyle() {
        myTableView.backgroundColor = UIColor(red: 240.0, green: 240.0, blue: 240.0, alpha: 0.2)
        myTableView.separatorColor = UIColor(red: 240.0, green: 240.0, blue: 240, alpha: 0.8)
    }
    
    //MARK: - Add gesture recognizer to the mini map
    @objc func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    //MARK: - Add pin annotation to the map
    func addPinAnnotation() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!) { (placemark, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            if let placemarks = placemark {
                //Get first placemark
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    //display the annotations
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    //set zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }
    
    //MARK: - Perform segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let destinationVC = segue.destination as? ReviewVC
            destinationVC?.restaurant = restaurant
        } else if segue.identifier == "showMap" {
            let destinationVC = segue.destination as? MapVC
            destinationVC?.restaurant = restaurant
        }
        
    }
    


    
    
    
}










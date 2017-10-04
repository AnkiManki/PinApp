//
//  AddRestaurantVC.swift
//  PinApp
//
//  Created by Stefan Markovic on 10/2/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit
import CoreData

class AddNewVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Variables
    var isVisited = false
    var restaurant: RestaurantMO!
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.roundButton()
        noButton.roundButton()
    }
    
    //MARK: - IBAction - save button
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }

        restaurant = RestaurantMO(context: context)
        restaurant.name = nameTextField.text
        restaurant.type = typeTextField.text
        restaurant.location = locationTextField.text
        restaurant.phone = phoneTextField.text
        restaurant.isVisited = isVisited
        
        if let restaurantImage = photoImageView.image {
            if let imageData = UIImagePNGRepresentation(restaurantImage) {
                restaurant.image = NSData(data: imageData) as Data
            }
        }

        appDelegate.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    //MARK: Chnage buttons color
    @IBAction func toggleBeenHereButtons(sender: UIButton) {
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = #colorLiteral(red: 0.8899894357, green: 0.449493885, blue: 0.2545161545, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.6619003415, green: 0.6625102758, blue: 0.6361036897, alpha: 1)
        } else if sender == noButton {
            isVisited = false
            yesButton.backgroundColor = #colorLiteral(red: 0.6545231938, green: 0.6551280618, blue: 0.6286643147, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.8865249753, green: 0.4494825602, blue: 0.2545202971, alpha: 1)
        }
    }
    
    //MARK: - TableView - select image
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Adjust Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    

}






















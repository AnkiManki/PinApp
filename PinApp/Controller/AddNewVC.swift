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

    }
    
    //MARK: - IBAction - save button
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
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
            yesButton.backgroundColor = UIColor.red
            noButton.backgroundColor = UIColor.gray
        } else if sender == noButton {
            isVisited = false
            yesButton.backgroundColor = UIColor.gray
            noButton.backgroundColor = UIColor.red
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






















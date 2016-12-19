//
//  NewPostViewController.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

protocol NewPostDelegate {
    func postComplete() -> Swift.Void
}

class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var foodTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postByLabel: UILabel!
    @IBOutlet weak var foodDescription: UITextView!
    var tapGesture: UIGestureRecognizer?
    var dismissGesture : UIGestureRecognizer?
    var delegate : CurrentPostsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTitleTextField.delegate = self
        foodDescription.delegate = self
        setUpGestures()

    }
    
    //MARK: text field delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: text view delegate methods
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    //MARK: tap gesture
    @objc func selectImage() {
        //instantiate image picker
        let imagePickerController = UIImagePickerController()
        
        //alert
        let pickerAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default) { action in
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        //set library for image picker's source type
        let libraryAction = UIAlertAction(title: "Library",
                                          style: .default) { action in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        pickerAlert.addAction(cameraAction)
        pickerAlert.addAction(libraryAction)
        pickerAlert.addAction(cancelAction)
        present(pickerAlert, animated: true, completion: nil)
    }
    
    
    //MARK: Image picker controller methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage!
        self.imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions -
    
    @IBAction func postButton(_ sender: UIButton) {
        let imageName = ImageUploader.generateImageName()
        ImageUploader.upload(image: imageView.image!, withName: imageName) {
            self.createFoodItem(withImageNamed: imageName)
        }
    }
    
    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Gesuture Methods
    
    func setUpGestures() {
        // Image selection
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        tapGesture?.delegate = self
        imageView.addGestureRecognizer(tapGesture!)
        imageView.isUserInteractionEnabled = true
        
        // First Responder Dismissal
        dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissGesture?.delegate = self
        view.addGestureRecognizer(dismissGesture!)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Save Method
    
    func createFoodItem(withImageNamed imageName: String) {
        let itemName = foodTitleTextField.text!
        let itemDescription = foodDescription.text
        let user = User.sharedInstance
        let ownerID = user.uid!
        let newItem = FoodItem(name: itemName, owner: ownerID, photo: imageName, description: itemDescription!, tags: [])
        
        FoodItem.saveToDatabase(item: newItem) { itemID in
            user.addFoodItem(withID: itemID) {
                self.delegate?.postComplete()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}

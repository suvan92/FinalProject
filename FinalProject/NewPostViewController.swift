//
//  NewPostViewController.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase



class NewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var foodTitleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postByLabel: UILabel!
    @IBOutlet weak var foodDescription: UITextView!
    var tapGesture: UIGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))

        tapGesture?.delegate = self
        imageView.addGestureRecognizer(tapGesture!)
        imageView.isUserInteractionEnabled = true
        foodTitleTextField.delegate = self
        foodDescription.delegate = self
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
        let pickerAlert = UIAlertController(title: "Get food post image", message: "Would you like to take a photo, or choose an image from your library?", preferredStyle: .actionSheet)
        
        
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
    
    // MARK: Posting Methods
    
    @IBAction func postButton(_ sender: UIButton) {
        let imageName = ImageUploader.generateImageName()
        ImageUploader.upload(image: imageView.image!, withName: imageName) {
            self.createFoodItem(withImageNamed: imageName)
        }
        
    }
    
    func createFoodItem(withImageNamed imageName: String) {
        let itemName = foodTitleTextField.text!
        let itemDescription = foodDescription.text
        let newItem = FoodItem(name: itemName, owner: nil, photo: imageName, description: itemDescription!, tags: [])
        
        FoodItem.saveToDatabase(item: newItem)
        
    }
    
    
    
    
    @IBAction func downloadImageButton(_ sender: UIButton) {
        let downloadImageRef = storageRef.child("images/373B4D74-853B-4356-9E0E-F45867EA4DB9.jpg")
        downloadImageRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let image = UIImage(data: data)
                self.imageView.image = image!
                self.imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    
    
}

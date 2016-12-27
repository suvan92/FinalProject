//
//  UserSettingsTableViewController.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-23.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class UserSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchRelativeLabel: UILabel!
    @IBOutlet weak var searchRelativeSwitch: UISwitch!
    @IBOutlet weak var addressStreetTF: UITextField!
    @IBOutlet weak var addressCityTF: UITextField!
    @IBOutlet weak var addressPostCodeTF: UITextField!
    @IBOutlet weak var addressCountryTF: UITextField!
    @IBOutlet weak var searchRadiusSlider: UISlider!
    @IBOutlet weak var searchRadiusLabel: UILabel!
    var searchRadius: Int = 1
    var locationManager: LocationManager?
    var locationLatitude: String?
    var locationLongitude: String?
    var tapGesture : UITapGestureRecognizer?
    var dismissGesture : UIGestureRecognizer?
    var isSearchByAddress: Bool = false
    let user: User = User.sharedInstance
    var postAlert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User Settings"
        setUpGestures()
        tableView.separatorStyle = .none
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
        //setupView()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    @IBAction func saveButtonTouched(_ sender: UIBarButtonItem) {
        self.showPostingAlert()
        ImageUploader.upload(profileImage: imageView.image!, foruser: user.uid!, completion: { (error) in
            if error == nil {
                self.locationFromTextFields(completion: { (error) in
                        self.setUserProperties()
                })
                
            } else {
                self.showErrorAlert()
            }
        })
    }
    
    @IBAction func searchRelativeClicked(_ sender: Any) {
        if searchRelativeSwitch.isOn {
            searchRelativeLabel.text = "Search relative to current location"
            isSearchByAddress = false
        } else {
            searchRelativeLabel.text = "Search relative to home address"
            isSearchByAddress = true
        }
    }
    
    @IBAction func radiusSliderChanged(_ sender: Any) {
        self.searchRadius = Int(self.searchRadiusSlider.value)
        self.searchRadiusLabel.text =  "\(self.searchRadius) km"
    }
    
    //MARK - address handling
    func locationFromTextFields(completion: @escaping (Error?) -> Swift.Void) {
        let locationString: String = "\(addressStreetTF.text!) \(addressCityTF.text!) \(addressPostCodeTF.text!) \(addressCountryTF.text!)"
        if locationString != "" {
            self.locationManager = LocationManager()
            self.locationManager?.placemarkFromString(address: locationString, completion: { error in
                if error != nil {
                } else {
                    self.locationLatitude = self.locationManager?.returnLatitudeString()
                    self.locationLongitude = self.locationManager?.returnLongitudeString()
                }
                completion(error)
            })            
        }
    }
    
    //MARK: Gesture handling
    func setUpGestures() {
        // Image Selection
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
    
    // MARK: - Image Picker -
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        
        // setup alert
        let pickerAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        })
        let libraryAction = UIAlertAction(title: "Library", style: .default) { action in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        pickerAlert.addAction(cameraAction)
        pickerAlert.addAction(libraryAction)
        pickerAlert.addAction(cancelAction)
        present(pickerAlert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage!
        self.imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    func setUserProperties(){
        user.username = self.usernameTextField.text
        user.isSearchByAddress = self.isSearchByAddress
        user.addressStreet = self.addressStreetTF.text
        user.addressCity = self.addressCityTF.text
        user.addressPostCode = self.addressPostCodeTF.text
        user.addressCountry = self.addressCountryTF.text
        user.homeLatitude = self.locationLatitude
        user.homeLongitude = self.locationLongitude
        user.searchRadius = self.searchRadius
        user.updateUserSettings() { error in
            if error != nil {
                self.showErrorAlert()
            } else {
                self.dismissView()
            }
            
        }
    }
    
    func showPostingAlert() {
        postAlert = UIAlertController(title: "Updating user settings...", message: nil, preferredStyle: .alert)
        present(postAlert!, animated: true, completion: nil)
    }
    
    func dismissView() {
        postAlert!.title = "Update complete!"
        postAlert!.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        postAlert!.title = "Update failed"
        postAlert!.message = "Please try again later"
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.postAlert!.dismiss(animated: true, completion: nil)
        }
        postAlert?.addAction(dismissAction)
    }
    
}



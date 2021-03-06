//
//  NewPostTableViewController.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-20.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class NewPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties -
    
    @IBOutlet weak var foodTitleTextField: UITextField!
    @IBOutlet weak var postByLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foodDescription: UITextView!
    @IBOutlet weak var tabcell: TagTextFieldTableViewCell!
    var tapGesture : UITapGestureRecognizer?
    var dismissGesture : UIGestureRecognizer?
    var postAlert : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setPostByLabel()
        setUpGestures()
        tabcell.setup()
        let nCentre = NotificationCenter.default
        nCentre.addObserver(forName: Notification.Name("tagMaximumReached"), object: nil, queue: nil, using: postTagAlert)
//        Attempt at auto resize cells for tags... not working.
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 140
    }
    
    func setPostByLabel() {
        let currentUser = User.sharedInstance
        if let username = currentUser.username {
            postByLabel.text = "Posted by: \(username)"
        } else {
            postByLabel.text = "Posted by: \(currentUser.email!)"
        }
    }
    
    // MARK: - Tap Gesture -
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        
        // alert
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //MARK: resize height of cell for tags
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Actions -
    
    @IBAction func cancelButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonTouched(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        showPostingAlert()
        let imageName = ImageUploader.generateImageName()
        ImageUploader.upload(image: imageView.image!, withName: imageName) { (error) in
            if error == nil {
                self.createFoodItem(withImageNamed: imageName)
            } else {
                self.showErrorAlert()
            }
        }
    }
    
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
    
    // MARK: - Save Methods -
    
    func createFoodItem(withImageNamed imageName: String) {
        let itemName = foodTitleTextField.text!
        let itemDescription = foodDescription.text!
        let user = User.sharedInstance
        let ownerID = user.uid!
        let longitude = user.homeLongitude
        let latitude = user.homeLatitude
        let tags = createTagsArray(itemName: itemName)
        if latitude != nil && longitude != nil {
            let newItem = FoodItem(name: itemName, owner: ownerID, photo: imageName, description: itemDescription, tags: tags, latitude: latitude!, longitude: longitude!)
            FoodItem.saveToDatabase(item: newItem) { itemID in
                user.addFoodItem(withID: itemID, completion: { (error) in
                    if error == nil {
                        let tagManager = TagManager()
                        tagManager.saveToDatabase(foodItem: newItem, completion: {
                            self.dismissView()
                        })
                    } else {
                        self.showErrorAlert()
                    }
                })
            }
        } else {
           showLocationErrorAlert()
        }
    }
    
    func createTagsArray(itemName: String) -> [String] {
        var result = tabcell.tags
        let titleArray = itemName.components(separatedBy: " ").map{$0.lowercased()}
        result.append(contentsOf: titleArray)
        return result
    }
    
    func showPostingAlert() {
        postAlert = UIAlertController(title: "Posting...", message: nil, preferredStyle: .alert)
        present(postAlert!, animated: true, completion: nil)
    }
    
    func dismissView() {
        postAlert!.title = "Post complete!"
        postAlert!.dismiss(animated: true) { [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showErrorAlert() {
        postAlert!.title = "Post failed"
        postAlert!.message = "Please try again later"
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.postAlert!.dismiss(animated: true, completion: nil)
        }
        postAlert?.addAction(dismissAction)
    }
    
    //MARK: Post alert if tag maximum reached
    func postTagAlert(notification: Notification) -> Void {
        postAlert = UIAlertController(title: "Sorry", message: "You have used your maximum available number of tags", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.postAlert?.dismiss(animated: true, completion: nil)
        }
        postAlert?.addAction(dismissAction)
        present(postAlert!, animated: true, completion: nil)
    }
    
    //MARK: No post address alert
    func showLocationErrorAlert() {
        postAlert!.title = "No address set"
        postAlert!.message = "Please complete your address in user settings and try again"
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.postAlert!.dismiss(animated: true, completion: nil)
        }
        postAlert?.addAction(dismissAction)
    }

}

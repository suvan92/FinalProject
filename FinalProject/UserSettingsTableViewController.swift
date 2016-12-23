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
    //var locationManager: LocationManager?
    var locationLatitude: String?
    var locationLongitude: String?
    var tapGesture : UITapGestureRecognizer?
    var dismissGesture : UIGestureRecognizer?
    var isSearchByAddress: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    @IBAction func saveButtonTouched(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func searchRelativeClicked(_ sender: Any) {
    }

}



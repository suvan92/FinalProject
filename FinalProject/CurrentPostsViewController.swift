//
//  CurrentPostsViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

let vcTitle = "Active Posts"
let createNewItemSegueIdentifier = "createNewPost"

class CurrentPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPosts : [String]?
    
    
    // MARK: - VC Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = vcTitle
        setUpView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
    // MARK: - Actions -
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: createNewItemSegueIdentifier, sender: self)
    }
    
    func setUpView() {
        arrayOfPosts = User.sharedInstance.postedItems
        
        if let arrayOfPosts = arrayOfPosts {
            // hide image view
        } else {
            tableView.isHidden = true
            // show image view
        }
        
    }


}

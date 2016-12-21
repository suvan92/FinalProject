//
//  CurrentPostsViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let vcTitle = "Active Posts"
let createNewItemSegueIdentifier = "createNewPost"
let itemCellIdentifier = "postCell"

class CurrentPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPosts : [FoodItem]?
    
    
    // MARK: - VC Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = vcTitle
        arrayOfPosts = []
        getDataSource()
    }
    
    // MARK: - TableVew Methods-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arrayOfPosts = arrayOfPosts {
            return arrayOfPosts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath) as! PostedItemTableViewCell
        if let arrayOfPosts = arrayOfPosts {
            let foodItem = arrayOfPosts[indexPath.row]
            cell.setUpCell(withItem: foodItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let foodItem = arrayOfPosts![indexPath.row]
        }
    }
    
    // MARK: - Actions -
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: createNewItemSegueIdentifier, sender: self)
    }
    
    // MARK: - General Methods -
    
    func getDataSource() {
        let currentUser = User.sharedInstance
        userRef.child(currentUser.uid!).child("postedItems").observe(.value, with: { snapshot in
            self.arrayOfPosts = []
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                ref.child(itemReferenceValue).observeSingleEvent(of: .value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    self.arrayOfPosts?.append(foodItem)
                    self.tableView.reloadData()
                })
            }
        })
    }
}

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
let pendingPostsVCSegueIdentifier = "showPendingRequestsVC"

class CurrentPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPosts : [FoodItem]?
    var selectedItem : FoodItem?
    
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = arrayOfPosts?[indexPath.row]
        performSegue(withIdentifier: pendingPostsVCSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == pendingPostsVCSegueIdentifier {
            let destinationVC = segue.destination as! PostPendingRequestsViewController
            destinationVC.foodItem = selectedItem
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
                foodRef.child(itemReferenceValue).observeSingleEvent(of: .value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    self.arrayOfPosts?.append(foodItem)
                    self.tableView.reloadData()
                })
            }
        })
    }
}

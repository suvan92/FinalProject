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

class CurrentPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewPostDelegate {

    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPosts : [FoodItem]?
    
    
    // MARK: - VC Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = vcTitle
        setUpView()
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
    
    // MARK: - Actions -
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: createNewItemSegueIdentifier, sender: self)
    }
    
    // MARK: - General Methods -
    
    func setUpView() {
        if arrayOfPosts == nil {
            tableView.isHidden = true
        }
    }
    
    func getDataSource() {
        let currentUser = User.sharedInstance
        userRef.child(currentUser.uid!).child("postedItems").observe(.value, with: { snapshot in
            
            for item in snapshot.children {
//                let foodItem = FoodItem(snapshot: item as! FIRDataSnapshot)
//                self.arrayOfPosts?.append(foodItem)
                // ITEM ONLY CONTAINS DATABASE REFERENCE TO FOODITEM, MUST GET FOODITEM FROM DATABASE USING USER'S REFERNCE URL
                print("current user's posted items: \(item)")
            }
        })
    }
    
    // MARK: - Segues -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == createNewItemSegueIdentifier {
            let destinationVC = segue.destination as! NewPostViewController
            destinationVC.delegate = self
        }
    }
    
    // MARK: - New Post Delegate Methods -
    func postComplete() {
        setUpView()
    }
}

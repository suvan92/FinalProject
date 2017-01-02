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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
        tableView.deselectRow(at: indexPath, animated: true)
        if (arrayOfPosts?[indexPath.row].requesterChosen)! {
            let destStory = UIStoryboard.init(name: "Messages", bundle: nil)
            let dest = destStory.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
            let selectedItem = arrayOfPosts?[indexPath.row]
            let channelId = selectedItem?.channel
            getChannel(with: channelId!, completion: { (channel) in
                dest.foodItem = selectedItem
                dest.channel = channel
                dest.channelRef = channel.databaseRef
                dest.senderDisplayName = channel.ownerUsername
                dest.title = channel.requesterUsername
                self.navigationController?.pushViewController(dest, animated: true)
            })
        } else {
            selectedItem = arrayOfPosts?[indexPath.row]
            performSegue(withIdentifier: pendingPostsVCSegueIdentifier, sender: self)
        }
    }
    

    //MARK: setupChannel
    func getChannel(with id: String, completion: @escaping(Channel) -> Swift.Void) {
        chanRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let channel = Channel(snapshot: snapshot)
            completion(channel)
        })
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let foodItem = arrayOfPosts?[indexPath.row]
            DeletionManager.delete(foodItem: foodItem!) {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Segues -
  
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
        // ordered query not working
        userRef.child(currentUser.uid!).child("postedItems").queryOrdered(byChild: "requesterChosen").observe(.value, with: { snapshot in
            self.arrayOfPosts = []
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe( .value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    self.arrayOfPosts?.append(foodItem)
                    self.tableView.reloadData()
                })
            }
        })
    }

}

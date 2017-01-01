//
//  ActiveMessagesViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class ActiveMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var postedItemsChannels: [Channel]?
    var requestedItemsData: [FoodItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let source = datasource {
//            return source.count
//        } else {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentChannels", for: indexPath)
//        cell.textLabel?.text = User.sharedInstance.channels?[indexPath.row]
        return cell
    }
    
    //MARK: tableview delegate methods
    //override??
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let channelId = datasource?[indexPath.row]
//        self.performSegue(withIdentifier: "ShowChannel", sender: channelId)
    }

    
    
    func getPostItems() {
        let currentUser = User.sharedInstance
        let currentUserRef = userRef.child(currentUser.uid!)
        currentUserRef.child("postedItems").observe(.value, with: { (snapshot) in
            var postedItems: [FoodItem] = []
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe(.value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    postedItems.append(foodItem)
                    self.getPostChannels(foodItems: postedItems)
                })
            }
        })
    }
    
    //you are here!! ***
    func getPostChannels(foodItems: [FoodItem]) {
        var channels: [String] = []
        for item in foodItems {
                    
            channels.append(item.channel)
        }
        
        
    }
    
    
}

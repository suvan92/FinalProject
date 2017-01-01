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
    var postedItemsChannels: [Channel]? = []
    var requestedItemsData: [FoodItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getPostItems()
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
                    print("FOOD ITEM: \(foodItem.name) POSTED ITEMS COUNT: \(postedItems.count)")
                    self.getPostChannels(foodItems: postedItems)
                })
            }
        })
    }
    
    //you are here!! *** WHY DOES THE CHANNEL GET ADDED TWICE?
    func getPostChannels(foodItems: [FoodItem]) {
        var channelRefs: [String] = []
        for item in foodItems {
            if item.requesterChosen {
                channelRefs.append(item.channel)
            }
        }
        print("CHANNEL REFS COUNT: \(channelRefs.count)")
        for ref in channelRefs {
            getChannel(with: ref, completion: { (channel) in
                self.postedItemsChannels?.append(channel)
                print("CHANNEL ADDED: \(channel.id). CHANNEL COUNT: \(self.postedItemsChannels?.count)")
            })
        }
    }
    
    //MARK: setupChannel
    func getChannel(with id: String, completion: @escaping(Channel) -> Swift.Void) {
        chanRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let channel = Channel(snapshot: snapshot)
            completion(channel)
        })
    }
}

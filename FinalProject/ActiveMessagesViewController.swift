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
    var postChanCount: Int = 0
    var requestedItemsData: [FoodItem]?
    
    override func viewDidLoad() {
        self.title = "Active Chats"
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getPostItems()
    }
    
    //MARK: tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (postedItemsChannels?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveChatTableViewCell", for: indexPath) as! ActiveChatTableViewCell
        let channel = (self.postedItemsChannels?[indexPath.row])! as Channel
        cell.setUpCellWith(channel: channel, isPostItem: true)
        return cell
    }
    
    //MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let channelId = datasource?[indexPath.row]
//        self.performSegue(withIdentifier: "ShowChannel", sender: channelId)
    }

    
    //MARK: datasource for posted items channels
    func getPostItems() {
        self.postedItemsChannels = []
        let currentUser = User.sharedInstance
        let currentUserRef = userRef.child(currentUser.uid!)
        currentUserRef.child("postedItems").observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe(.value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    self.getPostChannel(foodItem: foodItem)
                })
            }
        })
    }
    
    func getPostChannel(foodItem: FoodItem) {
        let item = foodItem
        if item.requesterChosen {
            postChanCount += 1
            let ref = item.channel
            getChannel(with: ref, completion: { (channel) in
                self.postedItemsChannels?.append(channel)
                self.tableView.reloadData()
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

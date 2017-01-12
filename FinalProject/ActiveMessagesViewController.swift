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
    var postTotalCount: Int = 0
    
    var requestedItemsChannels: [Channel]?
    var reqTotalCount: Int = 0
    
    var postView: UIView?
    var postLabel: UILabel?
    
    var stringItems: [String] = []
    
    struct Objects {
        var sectionName: String?
        var sectionObjects: [Channel]?
    }
    
    var datasource: [Objects] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
        self.tabBarItem = UITabBarItem(title: "Message", image: UIImage(named: "messageIconNeg"), tag: 3)
        //self.tabBarItem.badgeValue = ""
        
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Active Chats"
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        datasource = []
        getPostItems()
        getRequestItems()
    }
    
    //MARK: tableview datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = datasource[section].sectionObjects?.count {
            return number
        } else {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].sectionName
    }

    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
            returnedView.backgroundColor = ColorManager.lightRed()
    
            let label = UILabel(frame: CGRect(x: 10, y: 4, width: view.frame.size.width, height: 25))
            label.text = datasource[section].sectionName
            label.textColor = ColorManager.red()
            returnedView.addSubview(label)
    
            return returnedView
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveChatTableViewCell", for: indexPath) as! ActiveChatTableViewCell
        let channel = (datasource[indexPath.section].sectionObjects?[indexPath.row])! as Channel
        if datasource[indexPath.section].sectionName == "Your Requests" {
            cell.isPostItem = false
        } else {
            cell.isPostItem = true
        }
        cell.setUpCellWith(channel: channel)
        return cell
    }
    
    //MARK: tableview delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destStory = UIStoryboard.init(name: "Messages", bundle: nil)
        let dest = destStory.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        let channel = (datasource[indexPath.section].sectionObjects?[indexPath.row])! as Channel
        let cell = tableView.cellForRow(at: indexPath) as! ActiveChatTableViewCell
        if cell.isNewMessage {
            channel.isNewMsg = false
            cell.isNewMessage = false
        }
        channel.updateNewMessage(completion: { (error) in
            if (error != nil) {
                let err = (error?.localizedDescription)! as String
                print(err)
            }
        })
        if self.datasource[indexPath.section].sectionName == "Your Requests" {
            dest.senderDisplayName = channel.requesterUsername
            dest.title = channel.ownerUsername
            
        } else {
            dest.senderDisplayName = channel.ownerUsername
            dest.title = channel.requesterUsername
        }
        dest.channel = channel
        dest.channelRef = channel.databaseRef
        self.navigationController?.pushViewController(dest, animated: true)
    }

    
    //MARK: datasource for posted items channels
    func getPostItems() {
        self.postedItemsChannels = []
        let currentUser = User.sharedInstance
        let currentUserRef = userRef.child(currentUser.uid!)
        currentUserRef.child("postedItems").observe(.value, with: { (snapshot) in
            self.postTotalCount = Int(snapshot.childrenCount)
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe(.value, with: { snap in
                    print("POST SNAPSHOT RETURNED")
                    let foodItem = FoodItem(snapshot: snap)
                    self.getPostChannel(foodItem: foodItem)
                })
            }
        })
    }
    
    func getPostChannel(foodItem: FoodItem) {
        let item = foodItem
        if item.requesterChosen {
            let ref = item.channel
            getChannel(with: ref, completion: { (channel) in
                self.postedItemsChannels?.append(channel)
                if self.postTotalCount == self.postedItemsChannels?.count {
                    self.loadPostData()
                    self.tableView.reloadData()
                    self.checkImageRequired()
                }
            })
        } else {
            postTotalCount -= 1
            if self.postTotalCount == self.postedItemsChannels?.count {
                self.loadPostData()
                self.tableView.reloadData()
                checkImageRequired()
            }
        }
    }
    
    //MARK: datasource for requested items channels
    func getRequestItems() {
        self.requestedItemsChannels = []
        let currentUser = User.sharedInstance
        let currentUserRef = userRef.child(currentUser.uid!)
        currentUserRef.child("requestedItems").observe(.value, with: { (snapshot) in
            self.reqTotalCount = Int(snapshot.childrenCount)
            if self.reqTotalCount == 0 {
                self.checkImageRequired()
            } else {
                for item in snapshot.children {
                    let stringItem = ((item as! FIRDataSnapshot).value as! String)
                    //self.stringItems.append(stringItem)
                    foodRef.child(stringItem).observe(.value, with: { snap in
                        print("REQ SNAPSHOT RETURNED")
                        let foodItem = FoodItem(snapshot: snap)
                        self.getRequestChannel(foodItem: foodItem)
                    })
                }
            }
        })
    }
    
    func getRequestChannel(foodItem: FoodItem) {
        let item = foodItem
        let ref = item.channel
        print("REF IS: \(ref)")
        if ref != "" {
            getChannel(with: ref, completion: { (channel) in
                print("ENTERS GET CHANNEL")
                let user = User.sharedInstance
                if channel.requesterId == user.uid {
                    print("REQ HAS CHAT")
                    self.requestedItemsChannels?.append(channel)
                    if self.reqTotalCount == self.requestedItemsChannels?.count {
                        self.loadRequestData()
                        self.tableView.reloadData()
                    }
                } else {
                    print("NO CHAT")
                    self.reqTotalCount -= 1
                    if self.reqTotalCount == self.requestedItemsChannels?.count {
                        self.loadRequestData()
                        self.tableView.reloadData()
                    }
                }
                self.checkImageRequired()
            })
        } else {
            self.reqTotalCount -= 1
            if self.reqTotalCount == self.requestedItemsChannels?.count {
                self.loadRequestData()
                self.tableView.reloadData()
                checkImageRequired()
            }
        }
    }
    
    //MARK: setupChannel
    func getChannel(with id: String, completion: @escaping(Channel) -> Swift.Void) {
        chanRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let channel = Channel(snapshot: snapshot)
            completion(channel)
        })
    }
    
    func loadRequestData() {
        if let count = requestedItemsChannels?.count {
            if (count > 0) {
                let requestedObjects = Objects(sectionName: "Your Requests", sectionObjects: requestedItemsChannels)
                datasource.append(requestedObjects)
                self.tableView.reloadData()
            }
        }
    }
    
    func loadPostData() {
        if let count = postedItemsChannels?.count {
            if (count > 0) {
                let postedObjects = Objects(sectionName: "Your Posts", sectionObjects: postedItemsChannels)
                datasource.append(postedObjects)
                self.tableView.reloadData()
                checkImageRequired()
            }
        }
    }
    
    func checkImageRequired() {
        if self.datasource.count == 0 {
            self.setupView()
        } else {
            if self.postView != nil {
                self.postView?.isHidden = true
                self.view.sendSubview(toBack: self.postView!)
            }
        }
    }
    
    //MARK: set view if datasource is empty
    func setupView() {
        self.postView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(postView!)
        postView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        postView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        postView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.bringSubview(toFront: postView!)
        
        self.postLabel = {
            let label = UILabel()
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.numberOfLines = 2
            label.text = "You do not currently have any active chats"
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = ColorManager.red()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.postView?.addSubview(self.postLabel!)
        self.postLabel?.centerXAnchor.constraint(equalTo: (self.postView?.centerXAnchor)!).isActive = true
        self.postLabel?.centerYAnchor.constraint(equalTo: (self.postView?.centerYAnchor)!).isActive = true
        self.postLabel?.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.postView?.bringSubview(toFront: self.postLabel!)
    }
}

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
    
    var postView: UIView?
    var postLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
        self.tabBarItem = UITabBarItem(title: "Share", image: UIImage(named: "postIconNeg"), tag: 1)
        
    }

    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPosts : [FoodItem]?
    var selectedItem : FoodItem?
    
    
    // MARK: - VC Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = vcTitle
        self.automaticallyAdjustsScrollViewInsets = false
        let nCentre = NotificationCenter.default
        nCentre.addObserver(forName: Notification.Name("popToPost"), object: nil, queue: nil, using: refresh)
        getDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //getDataSource()
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
        self.selectedItem = arrayOfPosts?[indexPath.row]
        if (arrayOfPosts?[indexPath.row].requesterChosen)! {
            let destStory = UIStoryboard.init(name: "Messages", bundle: nil)
            let dest = destStory.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
            var updateFoodItem: FoodItem?
            let ref = self.selectedItem?.dataBaseRef
            foodRef.child(ref!).observe(.value, with: { snap in
                updateFoodItem = FoodItem(snapshot: snap)
                let channelId = updateFoodItem?.channel
                self.getChannel(with: channelId!, completion: { (channel) in
                    dest.foodItem = self.selectedItem
                    dest.channel = channel
                    dest.channelRef = channel.databaseRef
                    dest.senderDisplayName = channel.ownerUsername
                    dest.title = channel.requesterUsername
                    self.navigationController?.pushViewController(dest, animated: true)
                })
            })
                    } else {
            if (selectedItem?.requesters?.count) != nil {
                performSegue(withIdentifier: pendingPostsVCSegueIdentifier, sender: self)
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let foodItem = arrayOfPosts?[indexPath.row]
            DeletionManager.delete(foodItem: foodItem!) {
                self.tableView.reloadData()
                self.checkImageRequired()
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
        //var snapshotEmpty = true
        userRef.child(currentUser.uid!).child("postedItems").queryOrdered(byChild: "requesterChosen").observe(.value, with: { snapshot in
            //snapshotEmpty = false
            self.arrayOfPosts = []
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe( .value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    if self.arrayOfPosts?.count == 0 {
                        self.arrayOfPosts?.append(foodItem)
                    } else {
                        var isInArray: Bool = false
                        for item in self.arrayOfPosts! {
                            if item.dataBaseRef == foodItem.dataBaseRef {
                                isInArray = true
                            }
                        }
                        if !isInArray {
                            self.arrayOfPosts?.append(foodItem)
                        }
                    }
                    self.tableView.reloadData()
                    self.checkImageRequired()
                })
            }
        })
        self.checkImageRequired()
    }
    
    func checkImageRequired() {
        if self.arrayOfPosts?.count == 0 || self.arrayOfPosts == nil {
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
            label.text = "You do not currently have any posted food Items."
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = ColorManager.red()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.postView?.addSubview(self.postLabel!)
        self.postLabel?.centerXAnchor.constraint(equalTo: (self.postView?.centerXAnchor)!).isActive = true
        self.postLabel?.centerYAnchor.constraint(equalTo: (self.postView?.centerYAnchor)!).isActive = true
        self.postLabel?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.postView?.bringSubview(toFront: self.postLabel!)
    }
    
    func refresh(notification: Notification) -> Void {
        getDataSource()
    }
}

//
//  ActiveRequestsViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let requestVCTitle = "Active Requests"
let searchButtonSegueIdentifier = "searchButtonSegue"
let activeRequestsCellRI = "activeRequestsCell"

class ActiveRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postView: UIView?
    var postLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
        self.tabBarItem = UITabBarItem(title: "Request", image: UIImage(named: "requestIconNeg"), tag: 2)
        
    }
    
    
    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource : [FoodItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = requestVCTitle
        self.automaticallyAdjustsScrollViewInsets = false
        getDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - TableView Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activeRequestsCellRI, for: indexPath) as! ActiveRequestsTableViewCell
        
        if let dataSource = dataSource {
            cell.setUpCell(withItem: dataSource[indexPath.row])
        }
        
        return cell
    }
    
    func getDataSource() {
        let currentUser = User.sharedInstance
        let currentUserRef = userRef.child(currentUser.uid!)
        var snapshotEmpty = true
        currentUserRef.child("requestedItems").queryOrdered(byChild: "requesterChosen").observe(.value, with: { (snapshot) in
            snapshotEmpty = false
            self.dataSource = []
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe(.value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    self.dataSource?.append(foodItem)
                    self.tableView.reloadData()
                    self.checkImageRequired()
                })
            }
        })
        if snapshotEmpty {
            self.checkImageRequired()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destStory = UIStoryboard.init(name: "Messages", bundle: nil)
        let dest = destStory.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        let selectedItem = dataSource?[indexPath.row]
        let channelId = selectedItem?.channel
        getChannel(with: channelId!, completion: { (channel) in
            if channel.requesterId == User.sharedInstance.uid {
                dest.foodItem = selectedItem
                dest.channel = channel
                dest.channelRef = channel.databaseRef
                dest.senderDisplayName = channel.ownerUsername
                dest.title = channel.ownerUsername
                self.navigationController?.pushViewController(dest, animated: true)
            }
        })
    }
    
    //MARK: setupChannel
    func getChannel(with id: String, completion: @escaping(Channel) -> Swift.Void) {
        chanRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let channel = Channel(snapshot: snapshot)
            completion(channel)
        })
    }
    
    func checkImageRequired() {
        if self.dataSource?.count == 0 || self.dataSource == nil {
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
            label.text = "You do not currently have any active requests"
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

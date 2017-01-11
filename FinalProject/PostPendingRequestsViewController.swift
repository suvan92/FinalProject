
//
//  PostPendingRequestsViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let requesterCellReuseIdentifier = "requesterCell"

class PostPendingRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties -
    var foodItem : FoodItem?
    var dataSource : [RequestUser]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nCentre = NotificationCenter.default
        nCentre.addObserver(forName: Notification.Name("requesterChosen"), object: nil, queue: nil, using: createChannel)
        getDataSource()
    }
    
    // MARK: - TableView Methods -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: requesterCellReuseIdentifier, for: indexPath) as! RequesterTableViewCell
        
        if let dataSource = dataSource {
            let requestUser = dataSource[indexPath.row]
            cell.setUpCellWith(requestUser: requestUser, and: foodItem!)
        }
        
        return cell
    }
    
    // MARK: - General Methods -
    
    func getDataSource() {
        if let foodItem = foodItem {
            let itemRef = foodRef.child(foodItem.dataBaseRef)
            itemRef.child("requesters").observeSingleEvent(of: .value, with: { (snapshot) in
                self.dataSource = []
                for item in snapshot.children {
                    let requestUserRef = ((item as! FIRDataSnapshot).value as! String)
                    
                    userRef.child(requestUserRef).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let requestUser = RequestUser(snapshot: snapshot)
                        self.dataSource?.append(requestUser)
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }

    func createChannel(notification: Notification) -> Void {
        if notification.userInfo != nil {
            let requester = notification.userInfo?["requester"] as? RequestUser
            let channel = Channel(with: requester!, foodItemName: (self.foodItem?.name)!)
            channel.savetoDatabase {
                let id = channel.id
                self.foodItem?.addChannel(withID: id!, completion: {
                    print("channel added to foodItem succesfully")
                })
            }
        } else {
            print("failed to send requester")
            return
        }
        let _ = navigationController?.popViewController(animated: true)
        let nCentre = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: "popToPost"), object: self, userInfo: nil)
        nCentre.post(notification)
    }
}

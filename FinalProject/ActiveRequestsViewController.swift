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
    
    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource : [FoodItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = requestVCTitle
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
        let cell = tableView.dequeueReusableCell(withIdentifier: activeRequestsCellRI, for: indexPath) as! ActiveRequestsTableViewCell
        
        if let dataSource = dataSource {
            cell.setUpCell(withItem: dataSource[indexPath.row])
        }
        
        return cell
    }
    
    func getDataSource() {
        let currentUser = User.sharedInstance
        let currentUserRef = userRef.child(currentUser.uid!)
        currentUserRef.child("requestedItems").queryOrdered(byChild: "requesterChosen").observe(.value, with: { (snapshot) in
            self.dataSource = []
            for item in snapshot.children {
                let itemReferenceValue = ((item as! FIRDataSnapshot).value as! String)
                foodRef.child(itemReferenceValue).observe(.value, with: { snap in
                    let foodItem = FoodItem(snapshot: snap)
                    self.dataSource?.append(foodItem)
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

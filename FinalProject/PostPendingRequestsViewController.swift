
//
//  PostPendingRequestsViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

let requesterCellReuseIdentifier = "requesterCell"

class PostPendingRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties -
    var foodItem : FoodItem?
    var dataSource : [RequestUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.setUpCellWith(requestUser: dataSource[indexPath.row])
        }
        
        return cell
    }
    
    // MARK: - General Methods -
    
    func getDataSource() {
        if let foodItem = foodItem {
            let requestedUserRef = ref.child()
        }
    }

}

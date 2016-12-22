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

class ActiveRequestsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = requestVCTitle
    }

}

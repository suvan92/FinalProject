//
//  RequestSearchViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

let requestVCTitle = "Active Requests"
let searchButtonSegueIdentifier = "searchButtonSegue"

class RequestSearchViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = requestVCTitle
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: searchButtonSegueIdentifier, sender: self)
    }

}

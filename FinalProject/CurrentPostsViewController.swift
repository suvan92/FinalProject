//
//  CurrentPostsViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

let vcTitle = "Active Posts"
let createNewItemSegueIdentifier = "createNewPost"

class CurrentPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewPostDelegate {

    // MARK: - Properties -
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfPosts : [String]?
    
    
    // MARK: - VC Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = vcTitle
        setUpView()
    }
    
    // MARK: - TableVew Methods-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
    // MARK: - Actions -
    
    @IBAction func addButtonTouched(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: createNewItemSegueIdentifier, sender: self)
    }
    
    // MARK: - General Methods -
    
    func setUpView() {
        arrayOfPosts = User.sharedInstance.postedItems
        if arrayOfPosts == nil {
            tableView.isHidden = true
        }
    }
    
    // MARK: - Segues -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == createNewItemSegueIdentifier {
            let destinationVC = segue.destination as! NewPostViewController
            destinationVC.delegate = self
        }
    }
    
    // MARK: - New Post Delegate Methods -
    func postComplete() {
        setUpView()
    }
}

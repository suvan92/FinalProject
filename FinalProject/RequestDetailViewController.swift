//
//  RequestDetailViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class RequestDetailViewController: UIViewController {
    
    // MARK: - Properties -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var foodItem : FoodItem?
    var requestStatusAlert : UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        addRequestButton()
        if let foodItem = foodItem {
            setUpViewWithItem(foodItem)
        }
    }
    
    func addRequestButton() {
        let requestButton = UIBarButtonItem(title: "Request", style: .done, target: self, action: #selector(sendRequest))
        self.navigationItem.rightBarButtonItem = requestButton
    }
    
    func setUpViewWithItem(_ foodItem: FoodItem) {
        titleLabel.text = foodItem.name
        ImageDownloader.getFoodItemImage(foodItem: foodItem) { image in
            self.imageView.image = image
        }
        descriptionLabel.text = foodItem.itemDescription
    }
    
    func sendRequest() {
        showRequestingAlert()
        NewRequestManager.makeRequest(for: foodItem!) { error, canAdd in
            if canAdd != nil {
                self.requestAlreadyMadeAlert()
            } else if error == nil {
                self.requestCompleteAlert()
                self.dismissDetailView()
            } else {
                self.requestFailedAlert()
            }
        }
    }
    
    func showRequestingAlert() {
        requestStatusAlert = UIAlertController(title: "Requesting...", message: nil, preferredStyle: .alert)
        present(requestStatusAlert!, animated: true, completion: nil)
    }
    
    func requestCompleteAlert() {
        requestStatusAlert?.title = "Request successful!"
    }
    
    func requestAlreadyMadeAlert() {
        requestStatusAlert?.title = "You have already requested this item"
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismissDetailView()
        }
        requestStatusAlert?.addAction(dismissAction)
    }
    
    func requestFailedAlert() {
        requestStatusAlert?.title = "Request failed"
        requestStatusAlert?.message = "Please try again later"
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismissDetailView()
        }
        requestStatusAlert?.addAction(dismissAction)
    }
    
    func dismissDetailView() {
        requestStatusAlert?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    

}

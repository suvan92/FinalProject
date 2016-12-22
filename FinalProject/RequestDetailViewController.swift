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

    override func viewDidLoad() {
        super.viewDidLoad()
        if let foodItem = foodItem {
            setUpViewWithItem(foodItem)
        }
        
    }
    
    func setUpViewWithItem(_ foodItem: FoodItem) {
        titleLabel.text = foodItem.name
        ImageDownloader.getFoodItemImage(foodItem: foodItem) { image in
            self.imageView.image = image
        }
        descriptionLabel.text = foodItem.description
    }
    

}

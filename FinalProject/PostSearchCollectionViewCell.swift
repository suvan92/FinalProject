//
//  PostSearchCollectionViewCell.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-21.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class PostSearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties -
    
    @IBOutlet weak var foodItemTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setUpWithFoodItem(_ foodItem: FoodItem) {
        foodItemTitle.text = foodItem.name
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        ImageDownloader.getFoodItemImage(foodItem: foodItem, completion: { image in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFit
        })
        
    }
    
    
}

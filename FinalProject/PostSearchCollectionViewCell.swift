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
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setUpWithItemWithDistance(_ item: ItemWithDistance) {
        foodItemTitle.text = item.foodItem?.name
        distanceLabel.text = String(format: "Distance: %.1fkm", item.distance!)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        ImageDownloader.getFoodItemImage(foodItem: item.foodItem!, completion: { image in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFit
        })
    }
    
    
}

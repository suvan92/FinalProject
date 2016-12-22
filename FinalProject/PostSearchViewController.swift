//
//  PostSearchViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-21.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

let searchCellReuseIdentifier = "searchResultCell"

class PostSearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties -

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource : [FoodItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Search Bar Delegate Methods -
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchArray = searchBar.text!.components(separatedBy: " ")
        print(searchArray)
        let searchManager = SearchManager()
        searchManager.searchForItems(searchArray: searchArray, completion: {(foodItems) in
            self.dataSource = foodItems
            print(foodItems)
            self.collectionView.reloadData()
        })
        view.endEditing(true)
    }
    
    // MARK: - Collection View Methods -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellReuseIdentifier, for: indexPath) as! PostSearchCollectionViewCell
        
        cell.setUpWithFoodItem(dataSource[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.collectionView.frame.width*0.48
        let cellHeight : CGFloat = 200.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

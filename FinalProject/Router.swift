//
//  Router.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    // MARK: - Properties -
    
    var senderVC : UIViewController?
    
    // MARK: - Object Lifecyle -
    
    convenience init(_ vc: UIViewController) {
        self.init()
        self.senderVC = vc
    }
    
    
    // MARK: - Public functions -
    
    func showCurrentPosts() {
        senderVC?.show(Router.currentPostsVC(), sender: senderVC)
    }
    
    
    // MARK: - PostBranchVCs -
    
    fileprivate class func currentPostsVC() -> CurrentPostsViewController {
        return postBranch().instantiateViewController(withIdentifier: "CurrentPostsViewController") as! CurrentPostsViewController
    }
    
    
    // MARK: - Storyboards -
    
    fileprivate class func postBranch() -> UIStoryboard {
        return UIStoryboard(name: "PostBranch", bundle: nil)
    }

}

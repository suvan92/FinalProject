//
//  RequestSearchViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class RequestSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let searchEntry = "chocolate" //we can get this from the text field...
        let distance = 20 //We could get this from user settings, or a slider in the search vc
        let tagsRef = FIRDatabase.database().reference(withPath: "tags")
        
        tagsRef.queryEqual(toValue: searchEntry, childKey: "string").observe(.childAdded, with:  { snapshot in
            
            //some equation to convert the location into distance from user...
            //snapshot.value["location"]
            
            let posterDistance = 6
            
//            if posterDistance < distance {
//                returner
//                let age = snapshot.value["age"] as! Int
//                let fbKey = snapshot.key!
//                
//                print("array: \(fbKey)  \(age)  \(distance)")
//            }
        })
        
        
//        usersRef.queryOrderedByChild("age").queryStartingAtValue(20)
//            .queryEndingAtValue(25).observeEventType(.ChildAdded, withBlock: { snapshot in
//                
//                let distance = snapshot.value["distance"] as! Int
//                
//                if distance < 100 {
//                    let age = snapshot.value["age"] as! Int
//                    let fbKey = snapshot.key!
//                    
//                    print("array: \(fbKey)  \(age)  \(distance)")
//                }
//            })
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

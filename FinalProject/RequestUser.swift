//
//  RequestUser.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-22.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class RequestUser: NSObject {
    
    // MARK: - Properties -
    var name : String
    var email : String
    var uid: String
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String:Any?]
        
        name = snapshotValue["email"] as! String
        email = snapshotValue["email"] as! String
        uid = snapshotValue["uid"] as! String
        
    }

}

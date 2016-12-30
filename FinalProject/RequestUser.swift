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
    var username : String
    var email : String
    var uid: String
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String:Any?]
        
        username = snapshotValue["username"] as! String
        email = snapshotValue["email"] as! String
        uid = snapshotValue["uid"] as! String
    }

}

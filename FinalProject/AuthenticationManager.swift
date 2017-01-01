//
//  AuthenticationManager.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2017-01-01.
//  Copyright © 2017 suvanr. All rights reserved.
//

import UIKit
import Firebase

class AuthenticationManager: NSObject {
    
    class func createUser(withEmail email:String, password: String, completion: @escaping (Error?) -> Swift.Void) {
        
        FIRAuth.auth()!.createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                completion(error)
            } else {
                let currentUser = User.sharedInstance
                currentUser.uid = user?.uid
                currentUser.email = user?.email
                currentUser.saveToDatabase {
                    completion(nil)
                }
            }
        }
    }
    
    class func logUserIn(withEmail email:String, password:String, completion: @escaping (Error?) -> Swift.Void) {
        
        FIRAuth.auth()!.signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                completion(error)
            } else {
                let currentUser = User.sharedInstance
                currentUser.uid = user?.uid
                currentUser.email = user?.email
                currentUser.setupUserProperties {
                    completion(nil)
                }
            }
        }
        
        
    }

}

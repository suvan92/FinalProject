//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
        let signupController = UIAlertController(title: "Sign up",
                                                 message: "Input email and password",
                                                 preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        let signupAction = UIAlertAction(title: "Register",
                                         style: .default)
        { action in
            
            let email = signupController.textFields![0]
            let password = signupController.textFields![1]
            
            FIRAuth.auth()!.createUser(withEmail: email.text!, password: password.text!) { user, error in
                if error == nil {
                    print("signup successul!")
                } else {
                    print(error!.localizedDescription)
                }
                
            }
        }
        signupController.addTextField { textEmail in
            textEmail.placeholder = "Enter your email address"
        }
        signupController.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        signupController.addAction(signupAction)
        signupController.addAction(cancelAction)
        present(signupController, animated: true)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        
    }
    
    
    

}

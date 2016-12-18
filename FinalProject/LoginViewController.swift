//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-15.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

let loginSegueIdentifier = "loginSegue"

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
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
                    let currentUser = User.sharedInstance
                    currentUser.uid = user?.uid
                    currentUser.email = user?.email
                    currentUser.saveToDatabase()
                    
                    // currentUser.delegate = self
                    self.login(email: email.text!, password: password.text!)
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
        let email = emailTextField.text
        let password = passwordTextField.text
        
        login(email: email!, password: password!)
        
    }
    
    func login(email: String, password: String) {
        
        FIRAuth.auth()!.signIn(withEmail: email, password: password) { user, error in
            if error == nil {
                let currentUser = User.sharedInstance
                currentUser.uid = user?.uid
                //setup requires uid which hasn't been set in login
                currentUser.setupUserProperties()
                self.performSegue(withIdentifier: loginSegueIdentifier, sender: nil)
            } else {
                print(error!.localizedDescription)
            }
            
        }
    }
    
    
    

}

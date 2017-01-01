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
    
    // MARK: - Properties -
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var statusAlert : UIAlertController?
    var errorAlert : UIAlertController?
    var tapGesture : UITapGestureRecognizer?
    var isFirstLogin: Bool = false
    
    // MARK: - VCLifeCycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        buttonView.layer.cornerRadius = 6
        buttonView.layer.masksToBounds = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(endViewEditing))
        view.addGestureRecognizer(tapGesture!)
    }
    
    // MARK: - Actions -
    
    @IBAction func signupButton(_ sender: UIButton) {
        let signupController = UIAlertController(title: "Sign up",
                                                 message: "Input email and password",
                                                 preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        let signupAction = UIAlertAction(title: "Register",
                                         style: .default)
        { action in
            self.showCreatingAccountAlert()
            let email = signupController.textFields![0].text ?? ""
            let password = signupController.textFields![1].text ?? ""
            
            AuthenticationManager.createUser(withEmail: email, password: password, completion: { (error) in
                if error != nil {
                    self.showErrorAlert()
                } else {
                    self.statusAlert?.dismiss(animated: true, completion: nil)
                    self.isFirstLogin = true
                    self.login(email: email, password: password)
                }
            })
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
    
    // MARK: - General Methods
    
    func login(email: String, password: String) {
        showLoggingInAlert()
        AuthenticationManager.logUserIn(withEmail: email, password: password, completion: { (error) in
            if error != nil {
                self.statusAlert?.dismiss(animated: true, completion: {
                    self.showErrorAlert()
                })
            } else {
                self.statusAlert?.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: loginSegueIdentifier, sender: nil)
                })
            }
        })
    }
    
    func endViewEditing() {
        view.endEditing(true)
    }
    
    func showCreatingAccountAlert() {
        endViewEditing()
        statusAlert = UIAlertController(title: "Creating account...", message: nil, preferredStyle: .alert)
        present(statusAlert!, animated: true, completion: nil)
    }
    
    func showLoggingInAlert() {
        endViewEditing()
        statusAlert = UIAlertController(title: "Logging in...", message: nil, preferredStyle: .alert)
        present(statusAlert!, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        errorAlert = UIAlertController(title: "Invalid email/password", message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .default) { alert in
            self.errorAlert?.dismiss(animated: true, completion: nil)
        }
        errorAlert?.addAction(dismissAction)
        present(errorAlert!, animated: true, completion: nil)
    }
    
    // MARK: - Segues -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSegueIdentifier && self.isFirstLogin {
            if let tabVC = segue.destination as? UITabBarController {
                tabVC.selectedIndex = 3
                let navVC = tabVC.viewControllers?[3] as! UINavigationController
                let destVC = navVC.topViewController as! UserSettingsTableViewController
                destVC.isFirstVisit = true
            }
        }
    }
}

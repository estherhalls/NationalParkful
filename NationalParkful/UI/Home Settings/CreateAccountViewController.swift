//
//  CreateAccountViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Actions

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = usernameTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print ("Missing Text Field Data!")
            return
        }
        
        /// Create New Account
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("Account Creation Failed.")
                return
            }
            print("You have signed in!")
            strongSelf.usernameTextField.isHidden = true
            strongSelf.passwordTextField.isHidden = true
        }
        
        // Get Auth instance
        // Attempt Sign in
        // If Failure, present alert to create account
        // If user contine, create account
        // check sign in on app launch
        // allow user to sign out with button
        
    }
    
}

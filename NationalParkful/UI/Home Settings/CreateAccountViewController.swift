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

    }
    
    // MARK: - Actions
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        guard let email = usernameTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print ("Missing Text Field Data!")
            // add a notification to user that the text field must be populated with their data
            return
        }
        // Create New Account
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                print("Account Creation Failed.")
                return
            }
            /// When user creates account, it also logs them in.
            guard let user = authResult?.user else {return}
            UserDefaults.standard.set(user.uid, forKey: "uid")
            UserDefaults.standard.set(user.email, forKey: "email")
            
            print("You have signed in!")
            strongSelf.usernameTextField.placeholder = ""
            strongSelf.passwordTextField.placeholder = ""
            
            /// Set as signed in with Firebase
            UserDefaults.standard.set(true, forKey: "signedInWithFirebase")
            
            /// Display the home view via tab bar controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBar")
            
            /// This is to get the SceneDelegate object from your view controller
               /// then call the change root view controller function to change to main tab bar
               (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC)
        }
        
    }
    
} // End of Class

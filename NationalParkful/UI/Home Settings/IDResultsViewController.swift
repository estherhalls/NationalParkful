//
//  IDResultsViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class IDResultsViewController: UIViewController {
    // TODO: -

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Show signed in user email
        currentUserData()
    }
    
    // MARK: - Methods
    func currentUserData() {
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            emailLabel.text = email
        }
    }
    
    
    // MARK: - Actions
    @IBAction func signOutTapped(_ sender: Any) {
        
        // Clear the user interface.
   
        emailLabel.text = ""
        
        // Logout
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        // Display the login controller
        let userStoryboard = UIStoryboard(name: "UserSettings", bundle: nil)
        let loginVC = userStoryboard.instantiateViewController(withIdentifier: "Login")
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
        
    }
}

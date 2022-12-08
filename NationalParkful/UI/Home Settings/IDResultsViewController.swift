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
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        // Clear the user interface.
        userIDLabel.text = ""
        firstNameLabel.text = ""
        lastNameLabel.text = ""
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

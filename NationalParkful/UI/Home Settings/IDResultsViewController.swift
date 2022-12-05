//
//  IDResultsViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import UIKit
import AuthenticationServices

class IDResultsViewController: UIViewController {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDLabel.text = KeychainItem.currentUserIdentifier
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        // Clear the user interface.
        userIDLabel.text = ""
        firstNameLabel.text = ""
        lastNameLabel.text = ""
        emailLabel.text = ""
        
        // Display the login controller again.
        DispatchQueue.main.async {
            self.showUserSettingsViewController()
        }
    }
}

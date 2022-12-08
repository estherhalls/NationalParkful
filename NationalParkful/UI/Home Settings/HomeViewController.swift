//
//  HomeViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func userButtonTapped(_ sender: Any) {
    
        // Check if any user is signed in
        if Auth.auth().currentUser != nil {
            /// User is signed in. Go to IDResults View (using nav controller ID rather than view controller id so that title shows)
            let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let idResultsVC = storyboard.instantiateViewController(withIdentifier: "idResultsNav")

            self.present(idResultsVC, animated: true, completion: nil)

        } else {
            /// No user is signed in. Go to UserSettings (login - using nav controller ID rather than view controller id so that title shows)
            let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginNav")
            
            self.present(loginVC, animated: true, completion: nil)

        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  UserSettingsViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class UserSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginWithAppleStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Show programmatic sign in with apple button
        setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// Prompt user to sign in with Apple with a popup over screen so they are more likely to use this method
        performExistingAccountSetupFlows()
    }
    
    // MARK: - Methods
    
    /// Create Account Alert
    func showCreateAccount(){
        let alert = UIAlertController(title: "No Account Registered to this Email",
                                      message: "Create Account?",
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel",
                                          style: .cancel)
        let confirmAction = UIAlertAction(title: "Continue",
                                          style: .default,
                                          handler: { _ in
            DispatchQueue.main.async {
                /// Segue already exists, so perform that instead of present function or changing root vc
                self.performSegue(withIdentifier: "toCreateAccountVC", sender: nil)
            }
        })
        
        alert.addAction(dismissAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func rememberMeButtonChecked(_ sender: Any) {
        
    }
    
    @IBAction func forgotPWButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print ("Missing Text Field Data!")
            return
        }
        // Sign In Firebase Email User
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                strongSelf.showCreateAccount()
                return
            }
            print ("You have signed in!")
            strongSelf.emailTextField.placeholder = ""
            strongSelf.passwordTextField.placeholder = ""
            
            /// Display the home view via tab bar controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBar")
            
            /// This is to get the SceneDelegate object from your view controller
            /// then call the change root view controller function to change to main tab bar
            /// Use this rather than PresentVC function to clear memory and show home as root controller instead of card on top
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC)
        }
    }
    
    // MARK: - Login With Apple
    
    // Add Login with Apple Button
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self .loginWithAppleStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        startSignInWithAppleFlow()
    }
    
    // Perform Apple ID Request
    /// Starts authentication flow by checking user's email and full name, then system checks whether user is signed in with Apple ID on their device. If user is not signed in, the app presents an alert directing user to sign in with Apple ID in device Settings.
    /// User must enable 2FA to use sign in with apple so that account is secure
    
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        startSignInWithAppleFlow()
    }
    
    // Unhashed nonce.
    var currentNonce: String?
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = FirebaseService.randomNonceString()
        currentNonce = nonce
        UserDefaults.standard.set(false, forKey: "signedInWithFirebase")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = FirebaseService.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
} // End of Class

extension UserSettingsViewController: ASAuthorizationControllerPresentationContextProviding {
    /// Authorization controller calls presentationAnchor function to get the window from the app where it presents the sign in with apple content to the user in a modal sheet
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UserSettingsViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            /// Save authorised user ID for future reference
            let userIdentifier = appleIDCredential.user
            UserDefaults.standard.set(userIdentifier, forKey: "uid")
            
            
            /// Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            /// Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            /// Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            /// Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            // Sign in Apple with Firebase.
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                if (error != nil) {
                    /// Error. If error.code == .MissingOrInvalidNonce, make sure
                    /// you're sending the SHA256-hashed nonce as a hex string with
                    /// your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                // TODO: - fix fatal error: found nil
                // This allows firebase to store first name from Apple as display name. Worked first time, but I think I'm getting errors because this runs every time?
                /// User is signed in to Firebase with Apple.
                /// Make a request to set user's display name on Firebase
                //                                let changeRequest = authResult?.user.createProfileChangeRequest()
                //                                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                //                                changeRequest?.commitChanges(completion: { (error) in
                //
                //                                    if let error {
                //                                        print(error.localizedDescription)
                //                                    } else {
                //                                        print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
                //                                    }
                //                                })
                
                // Navigate back to Home after Logged in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBar")
                /// This is to get the SceneDelegate object from your view controller
                /// then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
} // Class



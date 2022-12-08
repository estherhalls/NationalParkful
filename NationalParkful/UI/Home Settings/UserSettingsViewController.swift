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
    /// I created an account with my email on December 6th and then signed in with my apple id associated with the same email December 7th. Firebase says that the account was created December 6th, but now says that the login provider is Apple. I believe the User UID did not change between them.
    
    // MARK: - Outlets
    @IBOutlet weak var loginWithAppleStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
                setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                self.performSegue(withIdentifier: "toCreateAccountVC", sender: nil)
            }
        })
        
        alert.addAction(dismissAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    
    // MARK: - Login With Apple
    
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
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
        /// Sign In Firebase User
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
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC)
        }
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
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                UserDefaults.standard.set(userIdentifier, forKey: "uid")
                UserDefaults.standard.set(appleIDCredential.email, forKey: "email")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBar")
                
                /// This is to get the SceneDelegate object from your view controller
                /// then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC)

            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            let userID = appleIDCredential.user
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
        
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
} // Class



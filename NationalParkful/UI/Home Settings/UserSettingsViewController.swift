//
//  UserSettingsViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import UIKit
import AuthenticationServices

class UserSettingsViewController: UIViewController {
    @IBOutlet weak var loginWithAppleStackView: UIStackView!
    
    // For each of your app's views that need information about the signed-in user, attach a listener to the FIRAuth object. This listener gets called whenever the user's sign-in state changes.
//    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { auth, user in
//          // ...
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performExistingAccountSetupFlows()
    }
    
    // MARK: - Login With Apple
    
    // Add Login with Apple Button
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self .loginWithAppleStackView
            .addArrangedSubview(authorizationButton)
    }
    
    // Apple ID PW Request
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
    
    // Perform Apple ID Request
    /// Starts authentication flow by checking user's email and full name, then system checks whether user is signed in with Apple ID on their device. If user is not signed in, the app presents an alert directing user to sign in with Apple ID in device Settings.
    /// User must enable 2FA to use sign in with apple so that account is secure
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// Authorization controller calls presentationAnchor function to get the window from the app where it presents the sign in with apple content to the user in a modal sheet
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

} // End of Class

extension UserSettingsViewController: ASAuthorizationControllerDelegate {
    // Did Complete Authorization (invoked function if authentication succeeds)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            self.saveUserInKeychain(userIdentifier)
            
            self.showIDResultsViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // Show password credential as an alert
            DispatchQueue.main.async {
                        self.showPasswordCredentialAlert(username: username, password: password)
                    }
        default:
            break
        }
    }
    
    // If authentication does not succeed:
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
}
extension UIViewController {
    
    func showUserSettingsViewController() {
        let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "userSettingsViewController") as? UserSettingsViewController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}

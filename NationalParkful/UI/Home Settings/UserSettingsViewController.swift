//
//  UserSettingsViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class UserSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginWithAppleStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    // For each of your app's views that need information about the signed-in user, attach a listener to the FIRAuth object. This listener gets called whenever the user's sign-in state changes.
    //    override func viewWillAppear(_ animated: Bool) {
    //        handle = Auth.auth().addStateDidChangeListener { auth, user in
    //          // ...
    //        }
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupProviderLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        performExistingAccountSetupFlows()
    }
    
    // MARK: - Methods
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
            
            /// Display the home view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBar")
            //            homeVC.modalPresentationStyle = .fullScreen
//            self?.present(homeVC, animated: true, completion: nil)
            
            // This is to get the SceneDelegate object from your view controller
               // then call the change root view controller function to change to main tab bar
               (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeVC)
        
           }
            
            
        }
        
        
        //
        //    // Check User Credentials at Launch
        //    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
        //            switch credentialState {
        //            case .authorized:
        //                break // The Apple ID credential is valid.
        //            case .revoked, .notFound:
        //                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
        //                DispatchQueue.main.async {
        //                    self.window?.rootViewController?.showLoginViewController()
        //                }
        //            default:
        //                break
        //            }
        //        }
        //        return true
        //    }
        //
        //    // MARK: - Login With Apple
        //
        //    // Add Login with Apple Button
        //    func setupProviderLoginView() {
        //        let authorizationButton = ASAuthorizationAppleIDButton()
        //        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        //        self .loginWithAppleStackView
        //            .addArrangedSubview(authorizationButton)
        //    }
        //
        //    // Apple ID PW Request
        //    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
        //    func performExistingAccountSetupFlows() {
        //        // Prepare requests for both Apple ID and password providers.
        //        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
        //                        ASAuthorizationPasswordProvider().createRequest()]
        //
        //        // Create an authorization controller with the given requests.
        //        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        //        authorizationController.delegate = self
        //        authorizationController.presentationContextProvider = self
        //        authorizationController.performRequests()
        //    }
        //
        //    // Perform Apple ID Request
        //    /// Starts authentication flow by checking user's email and full name, then system checks whether user is signed in with Apple ID on their device. If user is not signed in, the app presents an alert directing user to sign in with Apple ID in device Settings.
        //    /// User must enable 2FA to use sign in with apple so that account is secure
        //    @objc
        //    func handleAuthorizationAppleIDButtonPress() {
        //        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //        let request = appleIDProvider.createRequest()
        //        request.requestedScopes = [.fullName, .email]
        //
        //        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        //        authorizationController.delegate = self
        //        authorizationController.presentationContextProvider = self
        //        authorizationController.performRequests()
        //    }
        //
        //    /// Authorization controller calls presentationAnchor function to get the window from the app where it presents the sign in with apple content to the user in a modal sheet
        //    @objc(presentationAnchorForAuthorizationController:) func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        //        return self.view.window!
        //    }
        //
        //} // End of Class
        //
        //extension UserSettingsViewController: ASAuthorizationControllerDelegate {
        //    // Did Complete Authorization (invoked function if authentication succeeds)
        //    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //        switch authorization.credential {
        //        case let appleIDCredential as ASAuthorizationAppleIDCredential:
        //
        //            // Create an account in your system.
        //            let userIdentifier = appleIDCredential.user
        //            let fullName = appleIDCredential.fullName
        //            let email = appleIDCredential.email
        //
        //            //            self.saveUserInKeychain(userIdentifier)
        //
        //            self.showIDResultsViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        //
        //        case let passwordCredential as ASPasswordCredential:
        //
        //            // Sign in using an existing iCloud Keychain credential.
        //            let username = passwordCredential.user
        //            let password = passwordCredential.password
        //
        //            // Show password credential as an alert
        //            DispatchQueue.main.async {
        //                self.showPasswordCredentialAlert(username: username, password: password)
        //            }
        //        default:
        //            break
        //        }
        //    }
        //
        //    // If authentication does not succeed:
        //    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //        // Handle error.
        //    }
        //
        //    //    // Save User in Keychain
        //    //    private func saveUserInKeychain(_ userIdentifier: String) {
        //    //        do {
        //    //            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
        //    //        } catch {
        //    //            print("Unable to save userIdentifier to keychain.")
        //    //        }
        //    //    }
        //
        //    private func showIDResultsViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
        //        guard let viewController = self.presentingViewController as? IDResultsViewController
        //        else { return }
        //
        //        DispatchQueue.main.async {
        //            viewController.userIDLabel.text = userIdentifier
        //            if let givenName = fullName?.givenName {
        //                viewController.firstNameLabel.text = givenName
        //            }
        //            if let familyName = fullName?.familyName {
        //                viewController.lastNameLabel.text = familyName
        //            }
        //            if let email = email {
        //                viewController.emailLabel.text = email
        //            }
        //            self.dismiss(animated: true, completion: nil)
        //        }
        //    }
        //
        //    private func showPasswordCredentialAlert(username: String, password: String) {
        //        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        //        let alertController = UIAlertController(title: "Keychain Credential Received",
        //                                                message: message,
        //                                                preferredStyle: .alert)
        //        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        //        self.present(alertController, animated: true, completion: nil)
        //    }
        //}
        //
        //extension UIViewController {
        //
        //    func showUserSettingsViewController() {
        //        let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
        //        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "userSettingsViewController") as? UserSettingsViewController {
        //            loginViewController.modalPresentationStyle = .formSheet
        //            loginViewController.isModalInPresentation = true
        //            self.present(loginViewController, animated: true, completion: nil)
        //        }
        //    }
    }
    

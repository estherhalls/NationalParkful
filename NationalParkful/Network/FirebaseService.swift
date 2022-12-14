//
//  FirebaseService.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CryptoKit
import AuthenticationServices

/// May be it's own file if you want it more abstracted. Make sure this is outside of FirebaseService
enum FirebaseError: Error {
    case firebaseError(Error)
    case failedToUnwrapData
    case noDataFound
} // End of Enum

/// Makes data SOLID rather than a concrete type - Dependency Inversion
protocol FirebaseSyncable {
    /// underscore in save function is an empty argument label because log is also in our parameters
}


class FirebaseService: FirebaseSyncable {
    let ref = Firestore.firestore()
    
    // MARK: - User Collection: user data to and from Firebase
    
    //    func saveUser(_ appUser: AppUser) {
    /// UUID is what makes each entry unique. userData is what I named the unique dictionary representation of model object on AppUser model file.
    //        ref.collection(AppUser.Key.collectionType).document(appUser.uuid).setData(appUser.userData)
    //    }
    

    // MARK: - SIGN IN WITH APPLE
    /// I created an account with my email on December 6th and then signed in with my apple id associated with the same email December 7th. Firebase says that the account was created December 6th, but now says that the login provider is Apple. I believe the User UID did not change between them.
    
    /// For every sign-in request, generate a random string—a "nonce"—which you will use to make sure the ID token you get was granted specifically in response to your app's authentication request. This step is important to prevent replay attacks.
     static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    /// You will send the SHA256 hash of the nonce with your sign-in request, which Apple will pass unchanged in the response. Firebase validates the response by hashing the original nonce and comparing it to the value passed by Apple.
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
} // End of Class




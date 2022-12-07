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


struct FirebaseService: FirebaseSyncable {
    let ref = Firestore.firestore()
    
    // MARK: - User data to and from Firebase
    
    //    func saveUser(_ appUser: AppUser) {
    /// UUID is what makes each entry unique. userData is what I named the unique dictionary representation of model object on AppUser model file.
    //        ref.collection(AppUser.Key.collectionType).document(appUser.uuid).setData(appUser.userData)
    //    }
    
    
    // MARK: - FIREBASE USER
    // SIGN UP
    // SIGN IN
    // LOG OUT
    
    // MARK: - SIGN IN WITH APPLE
    private func randomNonceString(length: Int = 32) -> String {
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

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
} // End of Struct

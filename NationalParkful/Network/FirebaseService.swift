//
//  FirebaseService.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// User data to and from Firebase

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

//
//struct FirebaseService: FirebaseSyncable {
//    let ref = Firestore.firestore()
//
    
    
//    func saveUser(_ appUser: AppUser) {
        /// UUID is what makes each entry unique. userData is what I named the unique dictionary representation of model object on AppUser model file.
//        ref.collection(AppUser.Key.collectionType).document(appUser.uuid).setData(appUser.userData)
//    }
    
//} // End of Struct

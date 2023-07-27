//
//  AppUser.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation
// TODO: - create collections(users).documents(UID)
// App User > trips[0].parks[0].journal
class AppUser: Decodable {
    enum Key {
        static let collectionType = "users"
        static let email = "email"
        static let firebaseUID = "UID"
    }
    
    // Properties
    var email: String
    /// Needs to be Firebase UID that is assigned to each user
    let firebaseUID: String
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
    var userData: [String:AnyHashable] {
        [Key.email : self.email,
         Key.firebaseUID: self.firebaseUID
        ]
    }
    // MARK: - Designated Initializer
    init(email: String, firebaseUID: String = UUID().uuidString) {
        self.email = email
        self.firebaseUID = firebaseUID
    }
} // End of Class



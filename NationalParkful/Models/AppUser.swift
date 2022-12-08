//
//  AppUser.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation
// TODO: - create collections(users).documents(UID)
// App User > trips[0].parks[0].journal
struct AppUser: Decodable {
    enum Key {
        static let collectionType = "users"
        static let name = "name"
        static let email = "email"
        static let password = "password"
        static let uuid = "uuid"
    }
    
    // Properties
    var name: String
    var email: String
    var password: String
    /// Needs to be Firebase UID that is assigned to each user
    let uuid: UUID
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
    var userData: [String:AnyHashable] {
        [Key.name : self.name,
         Key.email : self.email,
         Key.password : self.password,
         Key.uuid: self.uuid
        ]
    }
    // MARK: - Designated Initializer
    init(name: String, email: String, password: String, uuid: UUID) {
        self.name = name
        self.email = email
        self.password = password
        self.uuid = uuid
    }
} // End of Struct



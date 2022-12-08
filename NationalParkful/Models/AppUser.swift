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
        static let trips = "trips"
        static let uuid = "uuid"
    }
    var trips: [Trip]
    // Needs to be Firebase UID that is assigned to each user
    let uuid: UUID
}


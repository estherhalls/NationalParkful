//
//  TripPark.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation
// TripParks are the parks added to each trip, which show the NPS shortName and first image, with user journal entry for each park
class TripPark: Decodable {
    // MARK: - Properties
    enum Key {
        static let parkUUID = "parkUUID"
        static let isFavorite = "isFavorite"
    }
    // Properties
    let parkUUID: String
    /// Park (isFavorite refers to park, not visit instance of the park)
    var isFavorite: Bool
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
    var tripParkData: [String:AnyHashable] {
        [Key.parkUUID : self.parkUUID,
         Key.isFavorite : self.isFavorite
        ]
    }
    
    // MARK: - Designated Initializer
    init(parkUUID: String = UUID().uuidString, isFavorite: Bool) {
        self.parkUUID = parkUUID
        self.isFavorite = isFavorite
    }
} // End of Class

// MARK: - Optional (Failable) Initializer Extension
///Allows us to use .compactMap for-in loop on FirebaseService
extension TripPark {
    convenience init?(fromDictionary topLevelDictionary: [String:Any]) {
        guard let uuid = topLevelDictionary[Key.parkUUID] as? String,
              let isFavorite = topLevelDictionary[Key.isFavorite] as? Bool
        else {return}
        self.init(parkUUID: uuid, isFavorite: isFavorite)
    }
}
// To allow deleting individual TripParks
extension TripPark: Equatable {
    static func == (lhs: TripPark, rhs: TripPark) -> Bool {
        return lhs.parkUUID == rhs.parkUUID
    }
}

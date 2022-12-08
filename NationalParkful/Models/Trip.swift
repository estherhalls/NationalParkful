//
//  Trip.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation
// Trip named by user, with start and end date and parks added
class Trip: Decodable {
    
    // MARK: - Properties
    enum Key {
        static let collectionType = "trips"
        static let tripName = "title"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let tripParks = "tripParks"
        static let tripSummary = "tripSummary"
        static let uuid = "uuid"
    }
    
    var tripName: String
    var startDate: Date
    var endDate: Date
    var tripParks: [TripPark]
    var tripSummary: String
    let uuid: String
    
    
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
//    var tripData: [String:AnyHashable] {
//        [Key.tripName : self.tripName,
//         Key.startDate : self.startDate.timeIntervalSince1970,
//         Key.endDate : self.endDate.timeIntervalSince1970,
//         Key.tripSummary : self.tripSummary,
//         Key.uuid : self.uuid
//        ]
//
//    }
    
    // MARK: - Designated Initializer
  
    
} // End of Class

// MARK: - Optional (Failable) Initializer Extension
///Allows us to use .compactMap for-in loop on FirebaseService

//extension Trip {
//    convenience init?(fromDictionary topLevelDictionary: [String:Any]) {
//        guard let title = topLevelDictionary[Key.tripName] as? String,
//              let startDate = topLevelDictionary[Key.startDate] as? Double,
//              let endDate = topLevelDictionary[Key.endDate] as? Double,
//              let parks = topLevelDictionary[Key.tripParks] as? String,
//              let tripSummary = topLevelDictionary[Key.tripSummary] as? String,
//              let uuid = topLevelDictionary[Key.uuid] as? String
//        else {return nil}
//
//        self.init
    
//    }
//}

// To allow deleting individual trips
extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

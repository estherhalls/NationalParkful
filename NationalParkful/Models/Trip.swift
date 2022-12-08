//
//  Trip.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation
// Trip named by user, with start and end date and parks added
/// Must be class and not struct if using failable init
class Trip: Decodable {
    
    // MARK: - Properties
    enum Key {
        static let collectionType = "trips"
        static let tripName = "title"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let tripSummary = "tripSummary"
        static let tripUUID = "tripUUID"
    }
    
    // Properties
    var tripName: String
    var startDate: Date
    var endDate: Date
    var tripSummary: String
    let tripUUID: String
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
    var tripData: [String:AnyHashable] {
        [Key.tripName : self.tripName,
         Key.startDate : self.startDate.timeIntervalSince1970,
         Key.endDate : self.endDate.timeIntervalSince1970,
         Key.tripSummary : self.tripSummary,
         Key.tripUUID : self.tripUUID
        ]
    }
    
    // MARK: - Designated Initializer
    init(tripName: String, startDate: Date, endDate: Date, tripSummary: String, uuid: String = UUID().uuidString) {
        self.tripName = tripName
        self.startDate = startDate
        self.endDate = endDate
        self.tripSummary = tripSummary
        self.tripUUID = uuid
    }
} // End of Class

// MARK: - Optional (Failable) Initializer Extension
///Allows us to use .compactMap for-in loop on FirebaseService
extension Trip {
    convenience init?(fromDictionary topLevelDictionary: [String:Any]) {
        guard let title = topLevelDictionary[Key.tripName] as? String,
              let startDate = topLevelDictionary[Key.startDate] as? Double,
              let endDate = topLevelDictionary[Key.endDate] as? Double,
              let tripSummary = topLevelDictionary[Key.tripSummary] as? String,
              let uuid = topLevelDictionary[Key.tripUUID] as? String
        else {return nil}
        
        self.init(tripName: title, startDate: Date(timeIntervalSince1970: startDate), endDate: Date(timeIntervalSince1970: endDate), tripSummary: tripSummary, uuid: uuid)
        
    }
}

// To allow deleting individual trips
extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.tripUUID == rhs.tripUUID
    }
}

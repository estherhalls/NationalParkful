//
//  Trip.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation

class Trip: Decodable {
    
    // MARK: - Properties
    enum Key {
        static let collectionType = "trips"
        static let tripName = "title"
        static let tripDates = "date_range"
        static let tripParks = "parks_visited"
        static let tripSummary = "trip_summary"
        static let parkJournals = "park_journals"
        static let uuid = "uuid"
    }
    
    var tripName: String
    var tripDates: Date
    var tripParks: ParkData
    var tripSummary: String
    var parkJournals: ParkJournal
    let uuid: String
    
    
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
    var tripData: [String:AnyHashable] {
        [Key.tripName : self.tripName,
         Key.tripDates : self.tripDates.timeIntervalSince1970,
         Key.tripParks : self.tripParks,
         Key.tripSummary : self.tripSummary,
         Key.parkJournals : self.parkJournals,
         Key.uuid : self.uuid
        ]
        
    }
    
    // MARK: - Designated Initializer
    init(tripName: String, tripDates: Date, tripParks: ParkData, tripSummary: String, parkJournals: ParkJournal, uuid: String = UUID().uuidString) {
        self.tripName = tripName
        self.tripDates = tripDates
        self.tripParks = tripParks
        self.tripSummary = tripSummary
        self.parkJournals = parkJournals
        self.uuid = uuid
    }
    
} // End of Class

// MARK: - Optional (Failable) Initializer Extension
///Allows us to use .compactMap for-in loop on FirebaseService

extension Trip {
    convenience init?(fromDictionary topLevelDictionary: [String:Any]) {
        guard let title = topLevelDictionary[Key.tripName] as? String,
              let dates = topLevelDictionary[Key.tripDates] as? Double,
              let parks = topLevelDictionary[Key.tripParks] as? String,
              let tripSummary = topLevelDictionary[Key.tripSummary] as? String,
              let parkJournals = topLevelDictionary[Key.parkJournals] as? String,
              let uuid = topLevelDictionary[Key.uuid] as? String
        else {return nil}
        
        self.init(tripName: title, tripDates: Date(timeIntervalSince1970: dates), tripParks: parks, tripSummary: tripSummary, parkJournals: parkJournals, uuid: uuid)
    }
}

extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

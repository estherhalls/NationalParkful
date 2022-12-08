//
//  Journal.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation

struct ParkJournal: Decodable {
    
    // MARK: - Properties
    enum Key {
        static let journalEntry = "journalEntry"
        static let parkVisitedDate = "parkVisitedDate"
    }
    
    // Properties
    var journalEntry: String
    var parkVisitedDate: Date?
    
    // Dictionary Representation of Model Objects
    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
    var parkJournalData: [String:AnyHashable] {
        [Key.journalEntry : self.journalEntry,
         Key.parkVisitedDate : self.parkVisitedDate?.timeIntervalSince1970
        ]
    }
    
    // MARK: - Designated Initializer
    init(journalEntry: String, parkVisitedDate: Date? = nil) {
        self.journalEntry = journalEntry
        self.parkVisitedDate = parkVisitedDate
    }
} // End of Struct


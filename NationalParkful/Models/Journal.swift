//
//  Journal.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

//import Foundation
//
//class ParkJournal: Decodable {
//    /// Park (isFavorite refers to park, not visit instance of the park)
//    var isFavorite: Bool
//    var journalEntry: String
//    var parkDate: Date?
//    let parkShortName: String
//    let parkImage: Image
//    let uuid
//    
//    
//    // Dictionary Representation of Model Objects
//    /// Used as value for child dictionary in save trip function on FirebaseService file. Computed property because it has a body that will be assigned the value.
//    var tripData: [String:AnyHashable] {
//        
//    }
//    
//    // MARK: - Designated Initializer
//    init(isFavorite: Bool, journalEntry: String, parkDate: Date? = nil, parkShortName: String, parkImage: Image) {
//        self.isFavorite = isFavorite
//        self.journalEntry = journalEntry
//        self.parkDate = parkDate
//        self.parkShortName = parkShortName
//        self.parkImage = parkImage
//    }
//} // End of Class

// MARK: - Optional (Failable) Initializer Extension
///Allows us to use .compactMap for-in loop on FirebaseService


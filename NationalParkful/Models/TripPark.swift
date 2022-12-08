//
//  TripPark.swift
//  NationalParkful
//
//  Created by Esther on 12/5/22.
//

import Foundation
// TripParks are the parks added to each trip, which show the NPS shortName and first image, with user journal entry for each park
struct TripPark: Decodable {
    
    let parkName: String
    let parkImage: Image
    var journalEntry: ParkJournal
    var isFavorite: Bool
    
    
    
}

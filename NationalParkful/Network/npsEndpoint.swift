//
//  npsEndpoint.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation

/// Abstract the creation of our URLs to allow us to use any enpoint we want using one inclusive/interchangable function rather than a full function for each endpoint
/// Use enum because it allows cases
enum ParksEndpoint {
    /// needs baseURL
    case parks
    /// needs  a URL component to be added to baseURL
    case park(String)
 
    
    // Computed property (open scope)
    var url: URL? {
        guard var baseURL = URL.baseURL else {return nil}
        baseURL.appendPathComponent("parkCode")
        
        switch self {
        case .parks:
            return baseURL
        case .park(let parkCode):
            baseURL.appendPathComponent(parkCode)
            return baseURL
     
        }
    }
}

// allow enum to access stored data
extension URL{
    static let baseURL = URL(string:"https://developer.nps.gov/api/v1")
}

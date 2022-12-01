//
//  ParkData.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation

struct TopLevelDictionary: Decodable {
    let data: [ParkData]
}

struct ParkData: Decodable {
    private enum CodingKeys: String, CodingKey {
        case fullName
        case shortName = "name"
        case parkCode
        case description
        case coordinates = "latLong"
        case activities
        case entranceFees
        case addresses
        case images
        case url
        case states
    }
    let fullName: String
    let shortName: String
    let parkCode: String
    let description: String
    let coordinates: String
    let activities: [ActivitiesList]
    let entranceFees: [FeeDetails]
    let addresses: [ParkAddress]
    let images: [Image]
    let url: String
    let states: String
}

struct ActivitiesList: Decodable {
    private enum CodingKeys: String, CodingKey {
        case activityName = "name"
    }
    let activityName: String
}

struct FeeDetails: Decodable {
    private enum CodingKeys: String, CodingKey {
        case cost
        case feeDescription = "description"
        case feeTitle = "title"
    }
    let cost: String
    let feeDescription: String
    let feeTitle: String
}

struct ParkAddress: Decodable {
    let city: String
    let stateCode: String

}

struct Image: Decodable {
    private enum CodingKeys: String, CodingKey {
        case imageCredit = "credit"
        case imageTitle = "title"
        case imageURL = "url"
    }
    let imageCredit: String
    let imageTitle: String
    let imageURL: String
}


/**
 Example of API data from top level:
 
 {
 "total": "467",
 "limit": "50",
 "start": "0",
 "data": [
 {
 "id": "77E0D7F0-1942-494A-ACE2-9004D2BDC59E",
 "url": "https://www.nps.gov/abli/index.htm",
 "fullName": "Abraham Lincoln Birthplace National Historical Park",
 "parkCode": "abli",
 "description": "For over a century people from around the world have come to rural Central Kentucky to honor the humble beginnings of our 16th president, Abraham Lincoln. His early life on Kentucky's frontier shaped his character and prepared him to lead the nation through Civil War. Visit our country's first memorial to Lincoln, built with donations from young and old, and the site of his childhood home.",
 "latitude": "37.5858662",
 "longitude": "-85.67330523",
 "latLong": "lat:37.5858662, long:-85.67330523",
 "activities": [
 {
 "id": "13A57703-BB1A-41A2-94B8-53B692EB7238",
 "name": "Astronomy"
 },
 */

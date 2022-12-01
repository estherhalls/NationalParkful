//
//  NetworkError.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation

/// Error Object for throwing errors on concurrent tasks
enum NetworkError: Error, LocalizedError {

    case invalidURL(String)
    case thrownError(Error)
    case noData
    case unableToDecode
    case noUser
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Unable to reach the server. Please try again.\(url)"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .noData:
            return "The server responded with no data. Please try again."
        case .unableToDecode:
            return "The server responded with bad data. Please try again."
        case .noUser:
            return "Do you need to sign in?"
        }
    }
} // End of Enum

//
//  NetworkError.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import Foundation

/// Error Object for throwing errors on concurrent tasks
enum NetworkError: Error, LocalizedError {

    case requestError(Error)
    case badURL
    case couldNotUnwrap
    case errorDecoding(Error)
  
    var localizedDescription: String {
        switch self {
        case .requestError(let error):
            return "Error performing the task: \(error.localizedDescription)"
        case .badURL:
            return "Unable to make the request with the given URL"
        case .couldNotUnwrap:
            return "Error parsing requested data"
        case .errorDecoding:
            return "Error ecountered when decoding the data"
        }
    }
} // End of Enum

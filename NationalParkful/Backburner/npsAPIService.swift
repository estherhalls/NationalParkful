//
//  NPSNetworkController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

//import Foundation
//
//// Read-only data from NPS API
//
///// Network Service for our Fetch Call
///// Data task here, decode when creating individual network calls in view models
///// Edit: decode in service provider files for each network call, then call in view models for dependency inversion (using a protocol instead of class or struct concrete type when dependency is involved)
//struct APIService {
//
//     func perform(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
//        // Data Task
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error {
//                completion(.failure(.requestError(error)))
//            }
//            if let response = response as? HTTPURLResponse {
//                print("Completed with a response of", response.statusCode)
//            }
//            // Check for Data
//            guard let data else {
//                completion(.failure(.errorDecoding))
//                return
//            }
//            completion(.success(data))
//        }.resume()
//    }
//} // End of Struct

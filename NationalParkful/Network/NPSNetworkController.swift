//
//  NPSNetworkController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//


import UIKit

struct NetworkController {

    // MARK: - URL
    // Base URL
    private static let baseURLString = "https://developer.nps.gov/api/v1"
    
    // Keys for URL Components
    private static let kParksComponent = "parks"
    private static let kAPIKeyKey = "api_key"
    private static let kAPIKeyValue = "uK121K0V4jZlhcQcEbSe3k8AfKLuMHda2970mUbb"
    private static let kParkCodeKey = "parkCode"
    private static let kLimitKey = "limit"
    private static let kLimitValue = "500"
    
    static func fetchParks(completion: @escaping (Result<TopLevelDictionary, NetworkError>) -> Void) {
        // Step 1: Get URL
        guard let baseURL = URL(string: baseURLString) else {
            completion(.failure(.invalidURL(baseURLString)))
            return
        }
        // Compose final URL
        let parksURL = baseURL.appendingPathComponent(kParksComponent)
        /// Add Query items with URLComponent Struct
        var urlComponents = URLComponents(url: parksURL, resolvingAgainstBaseURL: true)
        
        /// Query item
        let apiKeyQuery = URLQueryItem(name: kAPIKeyKey, value: kAPIKeyValue)
        let limitQuery = URLQueryItem(name: kLimitKey, value: kLimitValue)
        urlComponents?.queryItems = [apiKeyQuery, limitQuery]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL(baseURLString)))
            return
        }
        print (finalURL)
        
        // Step 2: Start a dataTask to retrieve data
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            /// Handle error first, new Xcode syntax does not require "error = error"
            if let error {
                /// New syntax for string interpolation
                completion(.failure(.thrownError(error)))
                return
            }
            // Check for Data
            guard let data = dTaskData else {
                completion(.failure(.noData))
                return
            }
            // Convert to JSON (do,try,catch)
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(.success(topLevelDictionary))
            } catch {
                completion(.failure(.unableToDecode)); return
            }
            // Resume starts dataTask and continues it. Tasks begin in suspended state.
        }.resume()
    } // End of Network Call 1
    
    // Network Call to fetch individual park data
    // The URL needs to be baseURL+kParksComponent+queryItems(ApiKey,ApiKeyValue)&(parkCodeKey,parkCodeKeyValue) or finalURL from fetchParks plus additional query item within final component of (parkCodeKey,parkCodeKeyValue)
    /// If I want to use the URL complete with components and query items found in fetchParks function, I would have had to have this constructed outside of both functions. For another time.
    static func fetchSinglePark(with parkCodeComponent: String, completion: @escaping(Result<ParkData, NetworkError>) -> Void) {
        // Step 1: Get URL
        // failable initializer has to be unwrapped (guard let)
        guard let baseURL = URL(string: baseURLString) else {
            completion(.failure(.invalidURL(baseURLString)))
            return
        }
        // Compose final URL
        let parksURL = baseURL.appendingPathComponent(kParksComponent)
        
        /// Add Query items with URLComponent Struct
        var urlComponents = URLComponents(url: parksURL, resolvingAgainstBaseURL: true)
        
        /// Query item
        let keyQuery = URLQueryItem(name: kAPIKeyKey, value: kAPIKeyValue)
        let parkCodeQuery = URLQueryItem(name: kParkCodeKey, value: parkCodeComponent)
        urlComponents?.queryItems = [keyQuery, parkCodeQuery]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL(baseURLString)))
            return
        }
        print (finalURL)
        
        // Step 2: Start a dataTask to retrieve data
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            /// Handle error first, new Xcode syntax does not require "error = error"
            if let error {
                /// New syntax for string interpolation
                completion(.failure(.thrownError(error)))
                return
            }
            // Check for Data
            guard let data = dTaskData else {
                completion(.failure(.noData))
                return
            }
            // Convert to JSON (do,try,catch)
            do {
                let park = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                completion(.success(park.data[0]))
            } catch {
                completion(.failure(.unableToDecode)); return
            }
            
            // Resume starts dataTask and continues it. Tasks begin in suspended state.
        }.resume()
    } // End of Network Call 2
    

    
    // Getting images from the internet requires network call with completion handler
    /// Remember to Import UIKit at top of file
    static func fetchImage(for parkImageURL: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        // Step 1 - Construct URL
        guard let url = URL(string: parkImageURL) else {return}
        
        //Step 2 - DataTask
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("🤬🤬🤬 There was an error with the image data task: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            ///guard let needs to return
            guard let imageData = data else {
                completion(.failure(.noData))
                return}
            guard let parkImage = UIImage(data: imageData) else {
                completion(.failure(.unableToDecode))
                return
            }
            completion(.success(parkImage))
            
        }.resume()
    } // End of Network Call 3
    
} // End of Struct

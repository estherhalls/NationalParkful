//
//  AllParksViewModel.swift
//  NationalParkful
//
//  Created by Esther on 8/1/23.
//

import Foundation
protocol AllParksViewModelDelegate: AllParksViewController {
    func successfullyLoadedData()
}

class AllParksViewModel {
    
    weak var delegate: AllParksViewModelDelegate?
    // Placeholder property
    var parksArray: [ParkData]?
    
    // DEPENDENCY INJECTION - why? To make our code easier to test.
    init(injectedDelegate: AllParksViewModelDelegate) {
        self.delegate = injectedDelegate
        fetchParks()
    }
    
    func fetchParks() {
        NetworkController.fetchParks {
            result in
            switch result {
            case .success(let topLevel):
                self.parksArray = topLevel.data
                self.delegate?.successfullyLoadedData()
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
}

//
//  ParkListTableViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import UIKit

class ParkListTableViewController: UITableViewController {
    
    
    // Placeholder property
    var topLevel: TopLevelDictionary?
    var parksArray: [ParkData] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkController.fetchParks { [weak self]
            result in
            switch result {
            case .success(let topLevel):
                self?.topLevel = topLevel
                self?.parksArray = topLevel.data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkCell", for: indexPath)
        let park = parksArray[indexPath.row]
        cell.textLabel?.text = "\(park.fullName)"
        cell.detailTextLabel?.text = "\(park.states)"
        
        return cell
    }
    
 
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC",
           let destinationVC = segue.destination as? ParkDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                // This is where we get the Park the user tapped on
                let parkToSend = self.parksArray[indexPath.row]
                // Fetch individual park
                NetworkController.fetchSinglePark(with: parkToSend.parkCode){ result in
                    switch result {
                    case .success(let park):
                        DispatchQueue.main.async {
                            destinationVC.parkData = park
                        }
                    case .failure(let error):
                        print("There was an error!", error.errorDescription!)
                    }
                }
            }
        }
    }
    
} // End of Class

//
//  ParkDetailViewController.swift
//  NationalParkful
//
//  Created by Esther on 12/1/22.
//

import UIKit

// Individual park information on this view

class ParkDetailViewController: UIViewController {
    
    @IBOutlet weak var parkCityNameLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkStateLabel: UILabel!
    @IBOutlet weak var parkCoordinatesLabel: UILabel!
    @IBOutlet weak var parkDescriptionTextView: UITextView!
    @IBOutlet weak var entranceFeeLabel: UILabel!
    @IBOutlet weak var parkFirstImage: UIImageView!
    @IBOutlet weak var parkActivitiesTableView: UITableView!
    
    var activities: [ActivitiesList] = []
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkActivitiesTableView.dataSource = self
        parkActivitiesTableView.delegate = self
    }
    
    // Reciever Property
    
    var parkData: ParkData? {
        didSet {
            updateViews()
        }
    }
    var cost: String = ""
 
    
    // MARK: - Helper Functions
    
    func hasCost() {
        guard let park = parkData else {return}
        let fees = park.entranceFees[0]
        if fees.cost == "0.00" {
            cost = "Free"
        } else {
            cost = "$\(fees.cost)"
        }
    }
    
    func updateViews() {
        guard let park = parkData else {return}
        let image = park.images[0]
        let address = park.addresses[0]
        
        NetworkController.fetchImage(for: image.imageURL) { [weak self] result in
            switch result {
            case.success(let image):
                
                DispatchQueue.main.async {
                    self?.hasCost()
                    
                    self?.parkNameLabel.text = park.shortName
                    self?.parkCityNameLabel.text = address.city
                    self?.parkStateLabel.text = address.stateCode
                    self?.parkCoordinatesLabel.text = park.coordinates
                    self?.parkDescriptionTextView.text = park.description
                    self?.entranceFeeLabel.text = self?.cost
                    self?.parkFirstImage.image = image
                    self?.activities = park.activities
            
                    self?.parkActivitiesTableView.reloadData()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }

    
// MARK: - Actions
    /// I want to navigate forward and back based on the current park placement on the index defined on the table view controller
    /// I will need to inform this detail view of that index and current position, and what to do at the beginning and end of index (loop back to beginning? end and stop showing the button for that direction in the index?)
    /// each button will need updateViews function at the end to repopulate with new park data
    
    @IBAction func previousParkButtonTapped(_ sender: Any) {
        
    }
    @IBAction func nextParkButtonTapped(_ sender: Any) {
    }
}

// MARK: - Extensions
extension ParkDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activity = activities[indexPath.row].activityName
        cell.textLabel?.text = activity
        return cell
    }
}

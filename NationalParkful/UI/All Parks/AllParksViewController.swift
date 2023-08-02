//
//  AllParksViewController.swift
//  NationalParkful
//
//  Created by Esther on 8/1/23.
//

import UIKit
import MapKit

class AllParksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    var viewModel: AllParksViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private let mapHeightRatio: CGFloat = 0.25
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AllParksViewModel(injectedDelegate: self)
        setupViews()
        
    }
    
    private func setupViews() {
        view.addSubview(map)
        view.addSubview(tableView)
        // Constraints for Map View
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: mapHeightRatio)
        ])
        
        // Constraints for Table View
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: map.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Map View Setup
        map.delegate = self
        
        // Table View Setup
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.parksArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
       if let park = viewModel.parksArray?[indexPath.row] {
            cell.textLabel?.text = "\(park.fullName)"
            cell.detailTextLabel?.text = "\(park.states)"
        }
        //        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
    
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        map.frame = view.bounds
//    }
//
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AllParksViewController: AllParksViewModelDelegate {
    
        func successfullyLoadedData() {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
}

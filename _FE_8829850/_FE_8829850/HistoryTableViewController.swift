//  HistoryTableViewController.swift
//  FE_8829850
//
//  Created by user228704 on 8/13/23.
//

import UIKit
import CoreLocation

// Define a class named HistoryTableViewController that inherits from UITableViewController
class HistoryTableViewController: UITableViewController {
    
    // Declare a variable to store the selected city name
    var cityName: String?
    
    // Define a struct to represent City information
    struct City {
        let name: String
        let latitude: Double
        let longitude: Double
        var image: UIImage? // Property to store city image
    }
    
    // Initialize an array of City objects with predefined city data
    var cities: [City] = [
        City(name: "Toronto", latitude: 43.6532, longitude: -79.3832, image: nil),
        City(name: "Vancouver", latitude: 49.2827, longitude: -123.1207, image: nil),
        // ... (other cities)
    ]
    
    // Initialize a Core Location geocoder
    let geocoder = CLGeocoder()
    
    // Connect the table view from the storyboard
    @IBOutlet weak var tableVC: UITableView!
    
    // This method is called after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view's delegate and data source to this view controller
        self.tableVC.delegate = self
        self.tableVC.dataSource = self
        
        // Register a prototype cell with the identifier "prototypeCell"
        tableVC.register(UITableViewCell.self, forCellReuseIdentifier: "prototypeCell")
        
        // Assign images to cities based on their names
        for index in 0..<cities.count {
            cities[index].image = UIImage(named: cities[index].name)
        }
        
        // Check if a city name is selected and add it to the cities array
        if let cityName = cityName, !cityName.isEmpty {
            fetchCityCoordinates(cityName) { latitude, longitude in
                let newCity = City(name: cityName, latitude: latitude, longitude: longitude, image: nil)
                self.addCity(newCity)
            }
        }
    }
    
    // Method to add a new city to the cities array and reload the table view
    func addCity(_ city: City) {
        cities.append(city)
        tableVC.reloadData()
    }

    // Method to fetch the coordinates of a city using Core Location geocoder
    func fetchCityCoordinates(_ cityName: String, completion: @escaping (Double, Double) -> Void) {
        geocoder.geocodeAddressString(cityName) { [weak self] placemarks, error in
            guard let _ = self, let placemark = placemarks?.first, error == nil else {
                return
            }
            
            if let location = placemark.location {
                completion(location.coordinate.latitude, location.coordinate.longitude)
            }
        }
    }

    // Action method for the "+" button to add a new city
    @IBAction func addButton(_ sender: Any) {
        // Create an alert box to input the city name
        let alertBox = UIAlertController(title: "Add City", message: "Enter the name of the city", preferredStyle: .alert)
        
        // Add a text field to the alert box
        alertBox.addTextField { textField in
            textField.placeholder = "Enter city name"
        }
        
        // Add "Cancel" action to the alert box
        alertBox.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add "Add" action to the alert box
        alertBox.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] alert in
            guard let self = self,
                  let textField = alertBox.textFields?.first,
                  let cityName = textField.text,
                  !cityName.isEmpty else {
                return
            }
            
            // Fetch coordinates for the entered city name and add the new city
            self.fetchCityCoordinates(cityName) { latitude, longitude in
                let newCity = City(name: cityName, latitude: latitude, longitude: longitude, image: nil)
                self.addCity(newCity)
            }
        }))
        
        // Present the alert box
        present(alertBox, animated: true)
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)
        
        let city = cities[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = """
            Name: \(city.name)
            Latitude: \(city.latitude)
            Longitude: \(city.longitude)
            """
        cell.imageView?.image = city.image ?? UIImage(named: "defaultImage") // Set city image or default image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

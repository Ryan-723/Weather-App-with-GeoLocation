//
//  MapViewController.swift
//  _FE_8829850
//
//  Created by user228704 on 8/11/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var cityName: String = ""
    
    // Connect UI elements from the storyboard
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityInfoLabel: UITextView!
    
    var selectedCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for the map view
        mapView.delegate = self
        configureMap()
    }
    
    // Method to configure the map view
    func configureMap() {
        print("Configuring map for city: \(cityName)")
        // Initialize a Core Location geocoder
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
            guard let self = self, let placemark = placemarks?.first, let location = placemark.location else {
                return
            }
            
            // Create a City instance with name and coordinates
            let city = City(name: self.cityName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.selectedCity = city
            
            // Create a map pin annotation and add it to the map
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            pin.title = city.name
            self.mapView.addAnnotation(pin)
            
            // Define a region for the map view and set its visible region
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
            
            // Update the city info label
            self.cityInfoLabel.text = "\(city.name)\nLatitude: \(city.latitude)\nLongitude: \(city.longitude)"
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func zoomSliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        // Create a new region with adjusted latitude and longitude deltas and set it to the map view
        let region = MKCoordinateRegion(
            center: mapView.region.center,
            span: MKCoordinateSpan(
                latitudeDelta: CLLocationDegrees(value * 2),
                longitudeDelta: CLLocationDegrees(value * 2)
            )
        )
        mapView.setRegion(region, animated: true)
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            // Create a pin annotation view for the map pin
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinAnnotation")
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
}

// Define a structure to represent City information
struct City {
    let name: String
    let latitude: Double
    let longitude: Double
}

//
//  RestaurantViewerViewModel.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation
import CoreLocation
import MapKit

@Observable class RestaurantViewerViewModel: NSObject {
    
    var restaurants: [Business] = []
    var currentIndex = 0
    var locationManager = CLLocationManager()
    @ObservationIgnored var latitude: Double = 37.334654741693086   // infintely recreates viewmodel again
    @ObservationIgnored var longitude: Double = -122.0089568407792
    var businessService: BusinessService!
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
}

extension RestaurantViewerViewModel: CLLocationManagerDelegate {
    
    // Called when to create CLLocationManager() and again when app's authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental control")
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            guard let coordinate = manager.location?.coordinate else { return }
            latitude = coordinate.latitude
            longitude = coordinate.longitude
            Task {
                let fetchedRestaurants = (try? await businessService.getBusinesses(latitude: latitude, longitude: longitude, term: "restaurants")) ?? []
                restaurants.append(contentsOf: fetchedRestaurants)
                restaurants.forEach { print($0.name) }
            }
            
        @unknown default:
            break
        }
    }
}

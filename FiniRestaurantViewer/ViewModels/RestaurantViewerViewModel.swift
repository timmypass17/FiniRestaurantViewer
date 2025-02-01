//
//  RestaurantViewerViewModel.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation
import CoreLocation
import MapKit

@MainActor  // ensure ui updates are on main thread
@Observable class RestaurantViewerViewModel: NSObject {
    
    var businesses: [Business] = []
    var currentIndex = 0
    var term = "restaurants"
    
    @ObservationIgnored var businessService: BusinessService!
    @ObservationIgnored var locationManager = CLLocationManager()
    @ObservationIgnored var latitude: Double = 37.334654741693086
    @ObservationIgnored var longitude: Double = -122.0089568407792
    @ObservationIgnored var isLoading = false
    @ObservationIgnored var page = 0
    @ObservationIgnored var limit = 20
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func loadMoreBusinesses() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            let fetchedRestaurants = try await businessService.getBusinesses(latitude: latitude, longitude: longitude, term: term, limit: limit, offset: page * limit)
            businesses.append(contentsOf: fetchedRestaurants)
            page += 1
        } catch {
            print("Error loading restaurants")
        }
        isLoading = false
    }
    
    func didTapSearchButton() async {
        businesses.removeAll()
        page = 0
        currentIndex = 0
        await loadMoreBusinesses()
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
                await loadMoreBusinesses()
            }
        @unknown default:
            break
        }
    }
}

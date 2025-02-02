//
//  RestaurantViewerViewModel.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

@MainActor
@Observable class RestaurantViewerViewModel: NSObject {
    
    var businesses: [Business] = []
    var term = "Restaurants"
    var currentIndex = 0
    
    @ObservationIgnored var businessService: BusinessService!
    @ObservationIgnored var favoriteService: FavoriteService!
    @ObservationIgnored var locationManager = CLLocationManager()
    @ObservationIgnored var latitude: Double = 37.334654741693086
    @ObservationIgnored var longitude: Double = -122.0089568407792
    @ObservationIgnored var isLoading = false
    @ObservationIgnored var page = 0
    @ObservationIgnored var limit = 20
    
    init(businessService: BusinessService, favoriteService: FavoriteService) {
        self.businessService = businessService
        self.favoriteService = favoriteService
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
            // Show alert to user that fetching business failed
        }
        isLoading = false
    }
    
    func didTapSearchButton() async {
        businesses.removeAll()
        page = 0
        currentIndex = 0
        await loadMoreBusinesses()
    }
    
    func addToFavorites(business: Business) {
        do {
            try favoriteService.addToFavorites(business: business)
            print("Added \(business.name) to favorites!")
        } catch {
            // Show alert to user that add to favorites failed
        }
    }
    
    func removeFromFavorites(businessID: String) {
        do {
            try favoriteService.removeFromFavorites(businessID: businessID)
            print("Removed \(businessID) from favorites!")
        } catch {
            // Show alert to user that remove from favorites failed
        }
    }
    
    func didTapPreviousButton(scrollProxy: ScrollViewProxy) {
        currentIndex = max(currentIndex - 1, 0)
        scrollProxy.scrollTo(currentIndex)
    }
    
    func didTapNextButton(scrollProxy: ScrollViewProxy) {
        currentIndex = min(currentIndex + 1, businesses.count - 1)
        scrollProxy.scrollTo(currentIndex)
        
        
        if currentIndex == businesses.count - 1 {
            Task {
                await loadMoreBusinesses()
            }
        }
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

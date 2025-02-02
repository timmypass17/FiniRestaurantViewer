//
//  FiniRestaurantViewerTests.swift
//  FiniRestaurantViewerTests
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Testing
@testable import FiniRestaurantViewer

struct FiniRestaurantViewerTests {
    
    let yelpService = YelpService()
    
    // Apple Park coordinates
    let latitude = 37.334654741693086
    let longitude = -122.0089568407792
    
    @Test func fetchRestaurants() async throws {
        let restaurants = try await yelpService.getBusinesses(latitude: latitude, longitude: longitude, term: "restaurants", limit: 20, offset: 0)
        #expect(restaurants.count > 0)
        #expect(restaurants.contains { $0.name == "Marufuku Ramen - Cupertino"} )
    }

}

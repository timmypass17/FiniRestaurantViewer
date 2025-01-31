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
    let latitude = 37.326026359388635
    let longitude = -121.855836348311
    
    @Test func fetchRestaurants() async throws {
        let restaurants = try await yelpService.getBusinesses(latitude: latitude, longitude: longitude, term: "restaurants")
        #expect(restaurants.count > 0)
        #expect(restaurants.contains { $0.name == "Blue Monkey Cafe & Restaurant"} )
    }

}

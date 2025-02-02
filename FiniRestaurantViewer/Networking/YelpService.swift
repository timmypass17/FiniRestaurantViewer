//
//  YelpService.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation

protocol BusinessService {
    func getBusinesses(latitude: Double, longitude: Double, term: String, limit: Int, offset: Int) async throws -> [Business]
}

// Responsible for interacting with Yelp API
class YelpService: BusinessService {
    
    func getBusinesses(latitude: Double, longitude: Double, term: String, limit: Int, offset: Int) async throws -> [Business] {
        let request = BusinessesAPIRequest(latitude: latitude, longitude: longitude, term: term, limit: limit, offset: offset)
        let businesses = try await sendRequest(request)
        return businesses
    }
}

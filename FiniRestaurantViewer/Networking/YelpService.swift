//
//  YelpService.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation

protocol BusinessService {
    func getBusinesses(latitude: Double, longitude: Double, term: String) async throws -> [Business]
}

class YelpService: BusinessService {
    
    func getBusinesses(latitude: Double, longitude: Double, term: String) async throws -> [Business] {
        let request = BusinessesAPIRequest(latitude: latitude, longitude: longitude, term: term)
        let businesses = try await sendRequest(request)
        return businesses
    }
    
}

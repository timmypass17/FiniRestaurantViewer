//
//  BusinessesAPIRequest.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation

let accessToken = "itoMaM6DJBtqD54BHSZQY9WdWR5xI_CnpZdxa3SG5i7N0M37VK1HklDDF4ifYh8SI-P2kI_mRj5KRSF4_FhTUAkEw322L8L8RY6bF1UB8jFx3TOR0-wW6Tk0KftNXXYx"

struct BusinessesAPIRequest: APIRequest {
    var latitude: Double
    var longitude: Double
    var term: String = "restaurants"    // TODO: Allow users to query anything (default to restaurants)
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")!
        urlComponents.queryItems = [
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "term": term
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        return request
    }

    func decodeResponse(data: Data) throws -> [Business] {
        let decoder = JSONDecoder()
        let businessesResponse = try decoder.decode(BusinessesResponse.self, from: data)
        return businessesResponse.businesses
    }
}

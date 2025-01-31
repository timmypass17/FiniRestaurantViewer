//
//  Business.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation

struct Business: Decodable {
    var id: String  // TODO: persist later in Core Data for favorites
    var name: String
    var imageUrl: String
    var rating: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case rating
    }
}

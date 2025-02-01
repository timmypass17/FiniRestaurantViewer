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
    var reviewCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case rating
        case reviewCount = "review_count"
    }
}

extension Business: Identifiable {
    static let sampleBusinesses: [Business] = [
        Business(id: "hXFhZ4GfetdiWaRmcCOUOw", name: "Curry Hyuga", imageUrl: "https://s3-media1.fl.yelpcdn.com/bphoto/bp69zbc-SdcV98GAlCBB9g/o.jpg", rating: 4.4, reviewCount: 125),
        Business(id: "__zS3k5SG4H45Wu-trFGeA", name: "Marufuku Ramen - Cupertino", imageUrl: "https://s3-media3.fl.yelpcdn.com/bphoto/_C8DWdRBVogdiuByuwZNcA/o.jpg", rating: 4.5, reviewCount: 225),
        Business(id: "1F3AI_bPzsttQHAOwR9Q-A", name: "Siam Station", imageUrl: "https://s3-media3.fl.yelpcdn.com/bphoto/Lt856NRkMLixssknKH8FHA/o.jpg", rating: 4.3, reviewCount: 45),
        Business(id: "Sc7E2PUCIwhQfwTvKf_p5A", name: "Home Eat", imageUrl: "https://s3-media3.fl.yelpcdn.com/bphoto/GyzRayHcRepRh3spHtrKCw/o.jpg", rating: 4.5, reviewCount: 400)
    ]
}


extension [Business] {
    func zIndex(_ business: Business) -> CGFloat {
        if let index = firstIndex(where: { $0.id == business.id }) {
            return CGFloat(count) - CGFloat(index)
        }
        
        return .zero
    }
}

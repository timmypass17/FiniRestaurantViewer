//
//  BusinessResponse.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import Foundation

struct BusinessesResponse: Decodable {
    var businesses: [Business]
}

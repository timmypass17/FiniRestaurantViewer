//
//  FiniRestaurantViewerApp.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import SwiftUI

@main
struct FiniRestaurantViewerApp: App {
    let persistenceController = PersistenceController.shared
    let yelpService = YelpService()
    
    var body: some Scene {
        WindowGroup {
            RestaurantViewerView(businessService: yelpService)
        }
    }
}

//
//  FiniRestaurantViewerApp.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import SwiftUI

@main
struct FiniRestaurantViewerApp: App {
    let yelpService = YelpService()
    let cdFavoriteService = CDFavoriteService()
    
    var body: some Scene {
        WindowGroup {
            RestaurantViewerView(
                restaurantViewerViewModel: RestaurantViewerViewModel(
                    businessService: yelpService,
                    favoriteService: cdFavoriteService
                )
            )
            .environment(\.managedObjectContext, CoreDataStack.shared.persistentContainer.viewContext)
        }
    }
}

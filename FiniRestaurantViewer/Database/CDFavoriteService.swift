//
//  FavoriteService.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 2/1/25.
//

import Foundation
import CoreData

protocol FavoriteService: AnyObject {
    func addToFavorites(business: Business) throws
    func removeFromFavorites(businessID: String) throws
}

// Responsible for saving user's favorites
class CDFavoriteService: FavoriteService {
    
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    func addToFavorites(business: Business) throws {
        let favoriteBusiness = FavoritedBusiness(context: context)
        favoriteBusiness.id = business.id
        favoriteBusiness.title = business.name
        try context.save()
    }
    
    func removeFromFavorites(businessID: String) throws {
        let fetchRequest: NSFetchRequest<FavoritedBusiness> = FavoritedBusiness.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", businessID)
        fetchRequest.fetchLimit = 1
        
        let results = try context.fetch(fetchRequest)
        if let result = results.first {
            context.delete(result)
            try context.save()
        }
    }
    
    
}

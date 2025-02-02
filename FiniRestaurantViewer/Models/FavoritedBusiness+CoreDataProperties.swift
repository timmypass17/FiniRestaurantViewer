//
//  FavoritedBusiness+CoreDataProperties.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 2/1/25.
//
//

import Foundation
import CoreData


extension FavoritedBusiness {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritedBusiness> {
        return NSFetchRequest<FavoritedBusiness>(entityName: "FavoritedBusiness")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?

}

extension FavoritedBusiness : Identifiable {

}

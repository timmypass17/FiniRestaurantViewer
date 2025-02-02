//
//  CoreDataStack.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 2/1/25.
//

import Foundation
import CoreData


class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FiniRestaurantViewer")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
}

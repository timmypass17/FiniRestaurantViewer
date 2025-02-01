//
//  Item.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    var color: Color
}

var items: [Item] = [
    Item(color: .red),
    Item(color: .blue),
    Item(color: .green),
    Item(color: .yellow),
    Item(color: .pink),
    Item(color: .purple)
]

extension [Item] {
    func zIndex(_ item: Item) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            return CGFloat(count) - CGFloat(index)
        }
        
        return .zero
    }
}

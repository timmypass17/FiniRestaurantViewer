//
//  CardView.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 2/1/25.
//

import SwiftUI
import CoreData

struct CardView: View {
    @Environment(RestaurantViewerViewModel.self) private var restaurantViewerViewModel
    @Environment(\.managedObjectContext) private var context
    let business: Business
    let index: Int
    let isFavorited: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: business.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()

            } placeholder: {
                Color.secondary
            }
            .frame(width: 300, height: 200)
            .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(index + 1). \(business.name)")
                        .foregroundStyle(.black)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button {
                        if isFavorited {
                            restaurantViewerViewModel.removeFromFavorites(businessID: business.id)
                        } else {
                            restaurantViewerViewModel.addToFavorites(business: business)
                        }
                    } label: {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isFavorited ? .yellow : .secondary)
                    }
                }
                RatingView(rating: business.rating, reviewCount: business.reviewCount)
            }
            .padding(12)
            
            Spacer()
            
        }
        .frame(width: 300, height: 350)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
    }
}

#Preview {
    CardView(business: Business.sampleBusinesses[0], index: 0, isFavorited: true)
}

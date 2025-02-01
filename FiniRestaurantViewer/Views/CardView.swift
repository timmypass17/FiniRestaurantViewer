//
//  CardView.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 2/1/25.
//

import SwiftUI

struct CardView: View {
    let business: Business
    let index: Int
    
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
                Text("\(index + 1). \(business.name)")
                    .foregroundStyle(.black)
                    .font(.title3)
                    .fontWeight(.semibold)
                
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
    CardView(business: Business.sampleBusinesses[0], index: 1)
        .border(.blue)
}

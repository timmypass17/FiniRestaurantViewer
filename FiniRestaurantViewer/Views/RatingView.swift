//
//  RatingView.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import SwiftUI

struct RatingView: View {
    let rating: Float
    let reviewCount: Int

    let maximumRating = 5
    let onColor: Color = .red
    let offColor: Color = .gray
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Image(systemName: "star.square.fill")
                    .foregroundStyle(Float(number) > rating ? offColor : onColor)
            }
            
            Text(String(format: "%.1f", rating))
                .padding(.leading, 8)
                .foregroundStyle(.foreground)
                        
            Text("\(reviewCount) Reviews")
                .padding(.leading, 8)
                .foregroundStyle(.secondary)
                
        }
    }
}

#Preview {
    RatingView(rating: 4, reviewCount: 316)
}

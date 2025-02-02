//
//  RestaurantViewerView.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import SwiftUI
import CoreData

// TODO: Pagination
struct RestaurantViewerView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FavoritedBusiness.title, ascending: true)])
    private var favoritedBusinesses: FetchedResults<FavoritedBusiness>
    
    @State var restaurantViewerViewModel: RestaurantViewerViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(restaurantViewerViewModel.businesses.indices, id: \.self) { index in
                            let business = restaurantViewerViewModel.businesses[index]
                            CardView(
                                business: business,
                                index: index,
                                isFavorited: favoritedBusinesses.contains { $0.id == business.id }
                            )
                            .id(index) // for scrollTo()
                            .frame(width: geometry.size.width)
                            .visualEffect { content, geometryProxy in
                                content
                                    .scaleEffect(
                                        scale(geometryProxy),
                                        anchor: .trailing)
                                    .rotationEffect(rotation(geometryProxy, rotation: 5))   // rotate card
                                    .offset(x: minX(geometryProxy)) // stacks them on top of eachother
                                    .offset(x: excessMinX(geometryProxy, offset: 8))
                            }
                            .zIndex(restaurantViewerViewModel.businesses.zIndex(business)) // to fix flipped deck overlapping
                            .environment(restaurantViewerViewModel)
                        }
                    }
                    .padding(.vertical, 15) // avoid top clipping when rotating
                }
                .scrollTargetBehavior(.paging)  // swipe to snap when scrolling
                .scrollIndicators(.hidden)
                .scrollDisabled(true)   // disable swipe gestures, no need to sync scrollID
                
                HStack {
                    Button {
                        withAnimation {
                            restaurantViewerViewModel.didTapPreviousButton(scrollProxy: scrollProxy)
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundStyle(.white)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                            }
                    }
                    
                    Button {
                        withAnimation {
                            restaurantViewerViewModel.didTapNextButton(scrollProxy: scrollProxy)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundStyle(.white)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.black)
                            }
                    }
                }
                .padding(.horizontal, 60)
                
                TextField("Search Term", text: $restaurantViewerViewModel.term)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 60)
                    .onSubmit {
                        Task {
                            await restaurantViewerViewModel.didTapSearchButton()
                        }
                    }
                    .submitLabel(.search)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bar)
        }
    }
    
    private func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    private func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let progress = (maxX / width) - 1.0
        let cappedProgress = min(progress, limit)
        
        return cappedProgress
    }
    
    private func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy)
        return 1 - (progress * scale)
    }
    
    private func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy)
        return progress * offset
    }
    
    private func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 5) -> Angle {
        let progress = progress(proxy)
        return Angle(degrees: progress * rotation)
    }
}

#Preview {
    let view = RestaurantViewerView(restaurantViewerViewModel: RestaurantViewerViewModel(businessService: YelpService(), favoriteService: CDFavoriteService()))
    view.restaurantViewerViewModel.businesses = Business.sampleBusinesses
    return view
}

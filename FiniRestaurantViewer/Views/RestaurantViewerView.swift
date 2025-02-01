//
//  RestaurantViewerView.swift
//  FiniRestaurantViewer
//
//  Created by Timmy Nguyen on 1/31/25.
//

import SwiftUI

// TODO: Pagination
struct RestaurantViewerView: View {
    
    @State var restaurantViewerViewModel: RestaurantViewerViewModel
    
    init(businessService: BusinessService) {
        let viewModel = RestaurantViewerViewModel()
        viewModel.businessService = businessService
        
        self.restaurantViewerViewModel = viewModel
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(restaurantViewerViewModel.restaurants.indices, id: \.self) { index in
                                CardView(business: restaurantViewerViewModel.restaurants[index])
                                    .id(index) // for ScrollViewReader's scrollTo()
                                    .padding(.horizontal, 65)
                                    .frame(width: geometry.size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .scaleEffect(
                                                scale(geometryProxy),
                                                anchor: .trailing)
                                            .rotationEffect(rotation(geometryProxy, rotation: 5))
                                            .offset(x: minX(geometryProxy)) // stacks them on top of eachother
                                            .offset(x: excessMinX(geometryProxy, offset: 8))
                                    }
                                    .zIndex(restaurantViewerViewModel.restaurants.zIndex(restaurantViewerViewModel.restaurants[index])) // to fix flipped deck overlapping
                            }
                        }
                        .padding(.vertical, 15) // avoid top clipping when rotating
                    }
                    .scrollTargetBehavior(.paging)  // swipe to snap
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)   // disable swipe gestures, no need to sync scrollID
                    
                    HStack {
                        Button {
                            withAnimation {
                                if restaurantViewerViewModel.currentIndex > 0 {
                                    restaurantViewerViewModel.currentIndex -= 1
                                    scrollProxy.scrollTo(restaurantViewerViewModel.currentIndex)
                                }
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
                                if restaurantViewerViewModel.currentIndex < restaurantViewerViewModel.restaurants.count - 1 {
                                    restaurantViewerViewModel.currentIndex += 1
                                    scrollProxy.scrollTo(restaurantViewerViewModel.currentIndex)
                                }
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
                }
                .frame(height: 450)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bar)
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
    let view = RestaurantViewerView(businessService: YelpService())
    view.restaurantViewerViewModel.restaurants = Business.sampleBusinesses
    return view
}

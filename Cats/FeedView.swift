//
//  ContentView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 25.02.2024.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject private var viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Welcome Cats")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(
                        Color(
                            uiColor: UIColor(
                                red: 96 / 255,
                                green: 120 / 255,
                                blue: 135 / 255,
                                alpha: 1
                            )
                        )
                    )
                Spacer()
            }
            .padding(.vertical, 30)
            
            LazyVGrid(
                columns: [
                    GridItem(spacing: 16),
                    GridItem()
                ],
                spacing: 16
            ) {
                ForEach(
                    Array(viewModel.breedsList.enumerated()),
                    id: \.offset
                ) { index, breed in
                    ZStack {
                        Rectangle()
                            .frame(height: 200)
                            .foregroundStyle(
                                Color(
                                    uiColor: UIColor(
                                        red: 159 / 255,
                                        green: 199 / 255,
                                        blue: 224 / 255,
                                        alpha: 0.3
                                    )
                                )
                            )
                        VStack {
                            Rectangle()
                                .foregroundStyle(Color(UIColor.clear))
                                .overlay {
                                    AsyncImage(url: viewModel.breedsImageURLs[breed.imageID ?? "mock"])
                                    { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: 200, maxHeight: 200)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .clipped()
                            Spacer()
                            Text(breed.name)
                                .fontWeight(.semibold)
                        }
                        .padding(.bottom, 8)
                    }
                    .cornerRadius(8)
                    
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
        .task {
            await viewModel.fetchBreeds()
        }
    }
}

#Preview {
    FeedView(
        viewModel: FeedViewModel(
            service: CatsNetworkProvider()
        )
    )
}

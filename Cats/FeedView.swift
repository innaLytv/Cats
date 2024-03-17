//
//  ContentView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 25.02.2024.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject private var viewModel: FeedViewModel
    @State private var showingSheet = false
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            title
            LazyVGrid(
                columns: [
                    GridItem(spacing: Constants.BreedCard.spacing),
                    GridItem()
                ],
                spacing:  Constants.BreedCard.spacing
            ) {
                ForEach(
                    Array(viewModel.breedsList.enumerated()),
                    id: \.offset
                ) {
                    index, breed in
                    BreedView(
                        imageURL: viewModel.breedsImageURLs[breed.imageID ?? "mock"],
                        title: breed.name,
                        height: Constants.BreedCard.height,
                        onTapAction: {
                            showingSheet.toggle()
                            viewModel.breedSelected(at: index)
                        }
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, Constants.horizontalSpacing)
        .task {
            await viewModel.fetchBreeds()
        }
        .fullScreenCover(isPresented: $showingSheet) {
            BreedDetailsView(
                viewModel: BreedDetailsViewModel(
                    breed: viewModel.lastSelectedBreed!, 
                    imageURL: viewModel.breedsImageURLs[viewModel.lastSelectedBreed!.imageID ?? "mock"]
                )
            )
        }
    }
}

private extension FeedView {
    var title: some View {
        HStack {
            Text(Constants.Title.text)
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(
                    Color(uiColor: Constants.Title.foregroundColor)
                )
            Spacer()
        }
        .padding(.vertical, Constants.Title.verticalPadding)
    }
}

private extension FeedView {
    enum Constants {
        static let horizontalSpacing = 20.0
        
        enum Title {
            static let text = "Select a breed"
            static let foregroundColor = UIColor(
                red: 96 / 255,
                green: 120 / 255,
                blue: 135 / 255,
                alpha: 1
            )
            static let verticalPadding = 30.0
        }
        enum BreedCard {
            static let height = 200.0
            static let spacing = 16.0
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

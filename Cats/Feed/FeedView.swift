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
            searchField
            breedsCollection
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, Constants.horizontalSpacing)
        .onAppear {
            viewModel.onAppear()
        }
        .fullScreenCover(isPresented: $showingSheet) {
            BreedDetailsView(
                viewModel: viewModel.breedDetailsViewModel
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
                    Color(Constants.Title.foregroundColor)
                )
            Spacer()
        }
        .padding(.top, Constants.Title.verticalSpacing)
    }
    
    var searchField: some View {
        TextField(
            Constants.Search.text,
            text: $viewModel.searchText
        )
        .onChange(of: viewModel.searchText) {
            viewModel.search(for: viewModel.searchText)
        }
        .padding(.all, Constants.Search.Spacing)
        .background(
            Color(Constants.Search.backgroundColor)
        )
        .foregroundColor(.black)
        .cornerRadius(Constants.Search.cornerRadius)
        .padding(.bottom, Constants.Search.bottomSpacing)
    }
    
    var breedsCollection: some View {
        LazyVGrid(
            columns: [
                GridItem(spacing: Constants.BreedCard.spacing),
                GridItem()
            ],
            spacing:  Constants.BreedCard.spacing
        ) {
            ForEach(
                Array(viewModel.displayedBreeds.enumerated()),
                id: \.offset
            ) { index, breed in
                BreedView(
                    imageURL: viewModel.breedsImageURLs[breed.id],
                    title: breed.name,
                    height: Constants.BreedCard.height
                )
                .onTapGesture {
                    showingSheet.toggle()
                    viewModel.breedSelected(breed)
                }
                .onAppear {
                    viewModel.breedShown(at: index)
                }
            }
        }
    }
}

private extension FeedView {
    enum Constants {
        static let horizontalSpacing = 20.0
        
        enum Title {
            static let text = "Choose your hero"
            static let foregroundColor = UIColor(r: 96, g: 120, b: 135, a: 1)
            static let verticalSpacing = 30.0
        }
        enum BreedCard {
            static let height = 200.0
            static let spacing = 16.0
        }
        enum Search {
            static let text = "Search"
            static let Spacing = 15.0
            static let backgroundColor = UIColor(r: 242, g: 242, b: 242, a: 1)
            static let cornerRadius = 8.0
            static let bottomSpacing = 20.0
        }
    }
}

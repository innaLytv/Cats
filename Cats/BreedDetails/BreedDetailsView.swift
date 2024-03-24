//
//  BreedDetailsView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 15.03.2024.
//

import Foundation

import SwiftUI

struct BreedDetailsView: View {
    @ObservedObject private var viewModel: BreedDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: BreedDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ZStack {
                        image
                        closeButton
                    }
                    ZStack {
                        contentView
                        VStack {
                            labelsStack
                            temperamentCollection
                            breedFeatures
                            Spacer(minLength: Constants.bottomSpacing)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, Constants.horizontalSpacing)
            .ignoresSafeArea()
            .background(
                Color(UIColor.systemBackground)
            )
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

private extension BreedDetailsView {
    var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Constants.Close.imageName)
                })
                .foregroundStyle(Color.gray)
            }
            .padding(.top, Constants.Close.topSpacing)
            .padding(.horizontal, Constants.horizontalSpacing)
            Spacer()
        }
    }
    
    var image: some View {
        Rectangle()
            .foregroundStyle(
                Color(UIColor.clear)
            )
            .frame(
                width: Constants.Image.width,
                height: Constants.Image.height
            )
            .overlay {
                AsyncImage(url: viewModel.imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            maxWidth: Constants.Image.width,
                            maxHeight: Constants.Image.height
                        )
                } placeholder: {
                    ProgressView()
                }
            }
            .clipped()
    }
    
    var breedFeatures: some View {
        VStack(spacing: Constants.BreedFeatures.verticalSpacing) {
            BreedFeatureView(
                filledPointsCount: viewModel.breed.intelligence,
                title: Constants.BreedFeatures.intelligence
            )
            BreedFeatureView(
                filledPointsCount: viewModel.breed.healthIssues,
                title: Constants.BreedFeatures.healthIssues
            )
            BreedFeatureView(
                filledPointsCount: viewModel.breed.childFrienly,
                title: Constants.BreedFeatures.childFriendly
            )
            BreedFeatureView(
                filledPointsCount: viewModel.breed.adaptability,
                title: Constants.BreedFeatures.adaptability
            )
            BreedFeatureView(
                filledPointsCount: viewModel.breed.socialNeeds,
                title: Constants.BreedFeatures.socialNeeds
            )
            
        }
        .padding(.horizontal, Constants.horizontalSpacing)
        .padding(.top, Constants.BreedFeatures.topSpacing)
    }
    
    var temperamentCollection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Constants.Temperament.horizontalSpacing) {
                ForEach(
                    viewModel.temperament,
                    id: \.self
                ) { temperament in
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.Temperament.cornerRadius)
                            .foregroundStyle(
                                Color(Constants.Temperament.backgroundColor)
                            )
                        Text(temperament)
                            .foregroundStyle(Color(UIColor.systemBackground))
                            .font(.callout)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding()
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalSpacing)
        }
    }
    
    var contentView: some View {
        Rectangle()
            .fill(
                Color(UIColor.systemBackground)
            )
            .cornerRadius(Constants.Content.cornerRadius)
            .frame(minHeight: Constants.Content.minHeight)
            .offset(y: Constants.Content.yOffset)
            .shadow(
                color: Color(Constants.Content.Shadow.color),
                radius: Constants.Content.Shadow.radius,
                y: Constants.Content.Shadow.yOffset
            )
    }
    
    var labelsStack: some View {
        VStack(
            alignment: .leading,
            spacing: Constants.Labels.spacing
        ) {
            HStack {
                Text(viewModel.breed.name)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(
                        Color(Constants.Title.foregroundColor)
                    )
                Spacer()
                NavigationLink(destination: {
                    BreedImageGalleryView(viewModel: viewModel.breedImageGalleryViewModel)
                }, label: {
                    Image(systemName: Constants.Labels.GalleryButton.imageName)
                        .foregroundStyle(
                            Color(Constants.Labels.GalleryButton.foregroundColor)
                        )
                        .font(.largeTitle)
                })
            }
            
            HStack {
                Text(Constants.Labels.originText(viewModel.breed.origin))
                Spacer()
            }
            
            HStack {
                Text(Constants.Labels.lifeSpanText(viewModel.breed.lifeSpan))
                Spacer()
            }
            
            Text(viewModel.breed.description)
                .font(.callout)
                .fontWeight(.regular)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, Constants.horizontalSpacing)
    }
}

private extension BreedDetailsView {
    enum Constants {
        static let horizontalSpacing = 30.0
        static let bottomSpacing = 48.0
        
        enum Image {
            static let width = UIScreen.main.bounds.width
            static let height = UIScreen.main.bounds.width * 1.35
        }
        enum Title {
            static let foregroundColor = UIColor(r: 96, g: 120, b: 135, a: 1)
        }
        enum BreedFeatures {
            static let adaptability = "Adaptability"
            static let childFriendly = "Child-friendly"
            static let healthIssues = "Health Issues"
            static let intelligence = "Intelligence"
            static let socialNeeds = "Social Needs"
            static let verticalSpacing = 16.0
            static let topSpacing = 12.0
        }
        enum Close {
            static let imageName = "xmark"
            static let topSpacing = 55.0
        }
        enum Temperament {
            static let horizontalSpacing = 8.0
            static let cornerRadius = 8.0
            static let backgroundColor = UIColor(r: 159, g: 199, b: 224, a: 1)
        }
        enum Content {
            static let cornerRadius = 8.0
            static let minHeight =  100.0
            static let yOffset = -20.0
            
            enum Shadow {
                static let color = UIColor.black.withAlphaComponent(0.1)
                static let radius = 5.0
                static let yOffset = -10.0
            }
        }
        enum Labels {
            static let spacing = 8.0
            static func originText(_ input: String) -> String {
                "Origin: \(input)"
            }
            static func lifeSpanText(_ input: String) -> String {
                "Life span: \(input) years"
            }
            
            enum GalleryButton {
                static let imageName = "photo.fill"
                static let foregroundColor = UIColor(r: 159, g: 199, b: 224, a: 1)
            }
        }
    }
}

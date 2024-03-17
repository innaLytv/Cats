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
        ScrollView {
            VStack {
                ZStack {
                    image
                    closeButton
                }
                ZStack {
                    Rectangle()
                        .fill(
                            Color(.white)
                        )
                        .cornerRadius(8)
                        .frame(minHeight: 100)
                        .offset(y: -20)
                        .shadow(
                            color: Color(UIColor.black.withAlphaComponent(0.1)),
                            radius: 5,
                            y: -10
                        )
                    
                    VStack {
                        VStack(spacing: 8) {
                            HStack {
                                Text(viewModel.breed.name)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(
                                        Color(uiColor: Constants.Title.foregroundColor)
                                    )
                                Spacer()
                            }
                            
                            HStack {
                                Text("Origin: \(viewModel.breed.origin)")
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            
                            HStack {
                                Text("Life span: \(viewModel.breed.lifeSpan) years")
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            
                            Text(viewModel.breed.description)
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundStyle(.black)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, Constants.horizontalSpacing)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                ForEach(
                                    viewModel.temperament,
                                    id: \.self
                                ) { temperament in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundStyle(
                                                Color(
                                                    uiColor: UIColor(
                                                        red: 159 / 255,
                                                        green: 199 / 255,
                                                        blue: 224 / 255,
                                                        alpha: 1
                                                    )
                                                )
                                            )
                                        Text(temperament)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding()
                                    }
                                }
                            }
                            .padding(.horizontal, Constants.horizontalSpacing)
                        }
                        
                        
                        VStack(spacing: 16) {
                            BreedFeatureView(
                                filledPointsCount: viewModel.breed.intelligence,
                                title: Constants.Strings.intelligence
                            )
                            BreedFeatureView(
                                filledPointsCount: viewModel.breed.healthIssues,
                                title: Constants.Strings.healthIssues
                            )
                            BreedFeatureView(
                                filledPointsCount: viewModel.breed.childFrienly,
                                title: Constants.Strings.childFriendly
                            )
                            BreedFeatureView(
                                filledPointsCount: viewModel.breed.adaptability,
                                title: Constants.Strings.adaptability
                            )
                            BreedFeatureView(
                                filledPointsCount: viewModel.breed.socialNeeds,
                                title: Constants.Strings.socialNeeds
                            )

                        }
                        .padding(.horizontal, Constants.horizontalSpacing)
                        .padding(.top, 12)
                        
                        Spacer(minLength: 48)
                        
                    }
                }
                
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .background(
            Color(.white)
        )
        .padding(.horizontal, Constants.horizontalSpacing)
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
                    Image(systemName: "xmark")
                })
                .foregroundStyle(Color.gray)
            }
            .padding(.top, 55)
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
                width: Constants.Image.side,
                height: Constants.Image.side * 1.35
            )
            .overlay {
                AsyncImage(url: viewModel.imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            maxWidth: Constants.Image.side,
                            maxHeight: Constants.Image.side * 1.35
                        )
                } placeholder: {
                    ProgressView()
                }
            }
            .clipped()
    }
}

private extension BreedDetailsView {
    enum Constants {
        static let horizontalSpacing = 30.0

        enum Image {
            static let side: CGFloat = {
                UIScreen.main.bounds.width/* - horizontalSpacing * 2*/
            }()
        }
        enum Title {
            static let foregroundColor = UIColor(
                red: 96 / 255,
                green: 120 / 255,
                blue: 135 / 255,
                alpha: 1
            )
        }
        enum Strings {
            static let adaptability = "Adaptability"
            static let childFriendly = "Child-friendly"
            static let healthIssues = "Health Issues"
            static let intelligence = "Intelligence"
            static let socialNeeds = "Social Needs"
        }
    }
}

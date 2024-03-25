//
//  BreedImageGalleryView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 23.03.2024.
//

import SwiftUI

struct BreedImageGalleryView: View {
    @ObservedObject private var viewModel: BreedImageGalleryViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: BreedImageGalleryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.shouldShowErrorState {
                    emptyStateView
                } else {
                    header
                    imagesCollection
                }
            }
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.refresh()
            }
            detailedImage
        }
        .onAppear {
            viewModel.onAppear()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

private extension BreedImageGalleryView {
    var header: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: Constants.Header.Back.imageName)
                    .frame(width: Constants.Header.Back.width, height: Constants.Header.Back.heigh)
                    .foregroundStyle(
                        Color(UIColor.label)
                    )
            }
            Spacer()
            HStack {
                Text(Constants.Header.Title.text)
                    .font(.largeTitle)
                    .fontWeight(.black)
                Spacer()
            }
        }
        .padding(.trailing, Constants.Header.trailingSpacing)
        .padding(.leading, Constants.Header.leadingSpacing)
        .padding(.bottom, Constants.Header.bottomSpacing)
        .padding(.top, Constants.Header.topSpacing)
    }
    
    var imagesCollection: some View {
        LazyVGrid(columns: [
            GridItem(spacing: Constants.Images.spacing),
            GridItem(spacing: Constants.Images.spacing),
            GridItem()
        ], spacing: Constants.Images.spacing) {
            ForEach(
                Array(viewModel.imageURLs.enumerated()),
                id: \.offset
            ) { index, imageURL in
                GalleryView(
                    imageURL: imageURL,
                    size: CGSize(width: Constants.Images.side, height: Constants.Images.side)
                )
                .onTapGesture {
                    viewModel.imageSelected(at: index)
                }
                .onAppear {
                    viewModel.imageShown(at: index)
                }
            }
        }
        .padding(.bottom, Constants.Images.bottomSpacing)
    }
    
    var detailedImage: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .frame(width: Constants.DetailedImage.Fade.size.width, height: Constants.DetailedImage.Fade.size.height)
                .opacity(viewModel.selectedImageIndex == nil ? 0 : Constants.DetailedImage.Fade.opacity)
                .animation(.easeInOut, value: viewModel.selectedImageIndex)
                .onTapGesture {
                    viewModel.imageSelected(at: nil)
                }
            GalleryView(
                imageURL: viewModel.selectedImageURL,
                size: CGSize(width: Constants.DetailedImage.side, height: Constants.DetailedImage.side),
                contentMode: .fit
            )
            .opacity(viewModel.selectedImageIndex == nil ? 0 : 1)
            .animation(.easeInOut, value: viewModel.selectedImageIndex)
        }
    }
    
    var emptyStateView: some View {
        ZStack {
            Image(
                Constants.EmptyState.imageName,
                bundle: .main
            )
            .padding(.top, Constants.EmptyState.topSpacing)
        }
    }
}

private extension BreedImageGalleryView {
    enum Constants {
        enum Header {
            static let trailingSpacing = 30.0
            static let leadingSpacing = 10.0
            static let bottomSpacing = 8.0
            static let topSpacing = 64.0
            
            enum Back {
                static let imageName = "arrow.backward"
                static let width = 44.0
                static let heigh = 44.0
            }
            enum Title {
                static let text = "Cuties!"
            }
        }
        enum Images {
            static let spacing = 0.0
            static let bottomSpacing = 64.0
            static let side = UIScreen.main.bounds.width / 3
        }
        enum DetailedImage {
            static let side = UIScreen.main.bounds.width
            
            enum Fade {
                static let opacity = 0.75
                static let size = UIScreen.main.bounds
            }
        }
        enum EmptyState {
            static let imageName = "somethingWentWrong"
            static let topSpacing = 64.0
        }
    }
}

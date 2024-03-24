//
//  BreedImageGalleryView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 23.03.2024.
//

import SwiftUI

struct BreedImageGalleryView: View {
    @ObservedObject private var viewModel: BreedImageGalleryViewModel
    @State var selectedImageIndex: Int?
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: BreedImageGalleryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                header
                imagesCollection
            }
            .scrollIndicators(.hidden)
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
                    size: CGSize(width: Constants.Images.side, height: Constants.Images.side),
                    backgroundColor: Constants.Images.backgroundColor
                )
                .onTapGesture {
                    selectedImageIndex = index
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
                .frame(width: Constants.DetailedImage.Fade.size.width, height: Constants.DetailedImage.Fade.size.height)
                .opacity(selectedImageIndex == nil ? 0 : Constants.DetailedImage.Fade.opacity)
                .animation(.easeInOut, value: selectedImageIndex)
                .onTapGesture {
                    selectedImageIndex = nil
                }
            GalleryView(
                imageURL: selectedImageIndex == nil ? nil : viewModel.imageURLs[selectedImageIndex!],
                size: CGSize(width: Constants.DetailedImage.side, height: Constants.DetailedImage.side),
                backgroundColor: .clear,
                contentMode: .fit
            )
            .opacity(selectedImageIndex == nil ? 0 : 1)
            .animation(.easeInOut, value: selectedImageIndex)
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
            static let backgroundColor = UIColor(r: 159, g: 199, b: 224, a: 0.3)
        }
        enum DetailedImage {
            static let side = UIScreen.main.bounds.width
            
            enum Fade {
                static let opacity = 0.75
                static let size = UIScreen.main.bounds
            }
        }
    }
}

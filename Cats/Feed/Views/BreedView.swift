//
//  BreedView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 15.03.2024.
//

import SwiftUI
import CachedAsyncImage

struct BreedView: View {
    private let imageURL: URL?
    private let title: String
    private let height: CGFloat
    
    init(
        imageURL: URL?,
        title: String,
        height: CGFloat
    ) {
        self.imageURL = imageURL
        self.title = title
        self.height = height
    }
    
    var body: some View {
        ZStack {
            backgroundView
            informationView
        }
        .cornerRadius(Constants.cornerRadius)
    }
}

private extension BreedView {
    var backgroundView: some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(
                Color(Constants.backgroundColor)
            )
    }
    
    var informationView: some View {
        VStack {
            Rectangle()
                .foregroundStyle(
                    Color(UIColor.clear)
                )
                .overlay {
                    CachedAsyncImage(url: imageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: height, maxHeight: height)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .clipped()
            Spacer()
            Text(title)
                .fontWeight(.semibold)
        }
        .padding(.bottom, Constants.bottomPadding)
    }
}

private extension BreedView {
    enum Constants {
        static let backgroundColor = UIColor(r: 159, g: 199, b: 224, a: 0.3)
        static let cornerRadius = 8.0
        static let bottomPadding = 8.0
    }
}


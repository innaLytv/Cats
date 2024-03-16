//
//  BreedView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 15.03.2024.
//

import SwiftUI

struct BreedView: View {
    private let imageURL: URL?
    private let title: String
    private let height: CGFloat
    private let onTapAction: () -> Void
    
    init(
        imageURL: URL?,
        title: String,
        height: CGFloat,
        onTapAction: @escaping () -> Void
    ) {
        self.imageURL = imageURL
        self.title = title
        self.height = height
        self.onTapAction = onTapAction
    }
    
    var body: some View {
        ZStack {
            backgroundView
            informationView
        }
        .cornerRadius(Constants.cornerRadius)
        .onTapGesture {
            onTapAction()
        }
    }
}

private extension BreedView {
    var backgroundView: some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(
                Color(uiColor: Constants.backgroundColor)
            )
    }
    
    var informationView: some View {
        VStack {
            Rectangle()
                .foregroundStyle(
                    Color(UIColor.clear)
                )
                .overlay {
                    AsyncImage(url: imageURL) { image in
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
        static let backgroundColor = UIColor(
            red: 159 / 255,
            green: 199 / 255,
            blue: 224 / 255,
            alpha: 0.3
        )
        static let cornerRadius = 8.0
        static let bottomPadding = 8.0
    }
}


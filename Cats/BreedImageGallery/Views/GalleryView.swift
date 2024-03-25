//
//  GalleryView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 24.03.2024.
//

import SwiftUI
import CachedAsyncImage

struct GalleryView: View {
    private let imageURL: URL?
    private let size: CGSize
    private let contentMode: ContentMode
    
    init(
        imageURL: URL?,
        size: CGSize,
        contentMode: ContentMode = .fill
    ) {
        self.imageURL = imageURL
        self.size = size
        self.contentMode = contentMode
    }
    
    var body: some View {
        Rectangle()
            .foregroundStyle(
                Color(.clear)
            )
            .frame(width: size.width, height: size.height)
            .overlay {
                CachedAsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(maxWidth: size.width, maxHeight: size.height)
                } placeholder: {
                    ProgressView()
                }
            }
            .clipped()
    }
}

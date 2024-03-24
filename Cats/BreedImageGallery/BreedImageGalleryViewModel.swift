//
//  BreedImageGalleryViewModel.swift
//  Cats
//
//  Created by Inna Lytvynenko on 23.03.2024.
//

import SwiftUI

final class BreedImageGalleryViewModel: ObservableObject {
    
    @Published var imageURLs: [URL?] = []
    private let service: CatsNetworkProviding
    private let breedId: String
    private var pageToLoadIndex = 0
    private let prefetchOffset = 5
    
    init(breedId: String, service: CatsNetworkProviding) {
        self.service = service
        self.breedId = breedId
    }
}

extension BreedImageGalleryViewModel {
    @MainActor
    func onAppear() {
        loadImages()
    }
    
    @MainActor
    func imageShown(at index: Int) {
        guard index == imageURLs.count - prefetchOffset else { return }
        loadImages()
    }
}

private extension BreedImageGalleryViewModel {
    @MainActor
    func loadImages() {
        Task {
            do {
                let imageData = try await service.getImages(of: breedId, limit: 25, page: pageToLoadIndex)
                imageURLs = imageData.map(\.url).map { URL(string: $0) }
            } catch {
                
            }
        }
    }
}

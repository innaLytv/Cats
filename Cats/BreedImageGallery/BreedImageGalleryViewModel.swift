//
//  BreedImageGalleryViewModel.swift
//  Cats
//
//  Created by Inna Lytvynenko on 23.03.2024.
//

import SwiftUI

final class BreedImageGalleryViewModel: ObservableObject {
    
    @Published var imageURLs: [URL?] = []
    @Published var selectedImageIndex: Int?
    @Published var shouldShowErrorState: Bool = false
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
    func refresh() {
        imageURLs = []
        pageToLoadIndex = 0
        loadImages()
    }
    
    @MainActor
    func imageShown(at index: Int) {
        guard index == imageURLs.count - prefetchOffset else { return }
        loadImages()
    }
    
    func imageSelected(at index: Int?) {
        selectedImageIndex = index
    }
    
    var selectedImageURL: URL? {
        guard let selectedImageIndex else { return nil }
        return self.selectedImageIndex == nil ? nil : imageURLs[selectedImageIndex]
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
                shouldShowErrorState = imageURLs.count == 0
            }
        }
    }
}

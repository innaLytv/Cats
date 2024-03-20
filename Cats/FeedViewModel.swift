//
//  FeedViewModel.swift
//  Cats
//
//  Created by Inna Lytvynenko on 11.03.2024.
//

import Combine
import SwiftUI

final class FeedViewModel: ObservableObject {
    private let service: CatsNetworkProviding
    var lastSelectedBreed: Breed?
    
    @Published var displayedBreeds: [Breed] = []
    @Published var breedsImageURLs: [String: URL] = [:]
    @Published var searchText: String = ""
    private var breedsList: [Breed] = []
    private var searchTask: Task<Void, Error>?
    
    init(service: CatsNetworkProviding) {
        self.service = service
    }
    
    let mockImage = URL(string: "https://www.shutterstock.com/shutterstock/photos/1883859943/display_1500/stock-photo-the-word-example-is-written-on-a-magnifying-glass-on-a-yellow-background-1883859943.jpg")!
}

extension FeedViewModel {
    @MainActor
    func fetchBreeds() async {
        do {
            breedsList = try await service.getAllBreeds(page: 0)
            displayedBreeds = breedsList
            for breed in breedsList {
                guard let imageID = breed.imageID else { continue }
                let imageURL = try await service.getRandomImage(of: imageID).url
                breedsImageURLs[imageID] = URL(string: imageURL)
            }
            breedsImageURLs["mock"] = mockImage
        } catch { }
    }
    
    func breedSelected(at index: Int) {
        lastSelectedBreed = breedsList[index]
    }
    
    @MainActor
    func search(for query: String) {
        guard !query.isEmpty else {
            displayedBreeds = breedsList
            return
        }
        searchTask?.cancel()
        searchTask = Task {
            do {
                try Task.checkCancellation()
                displayedBreeds = try await service.searchBreeds(by: query)
            } catch { }
        }
    }
}

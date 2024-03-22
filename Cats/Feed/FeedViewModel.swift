//
//  FeedViewModel.swift
//  Cats
//
//  Created by Inna Lytvynenko on 11.03.2024.
//

import Combine
import SwiftUI

final class FeedViewModel: ObservableObject {
    
    @Published var displayedBreeds: [Breed] = []
    @Published var breedsImageURLs: [String: URL] = [:]
    @Published var searchText: String = ""
    private var allBreeds: [Breed] = []
    private var searchTask: Task<Void, Error>?
    private let service: CatsNetworkProviding
    private var lastLoadedBreedsPage = 0
    private let prefetchOffset = 5
    
    var lastSelectedBreed: Breed?
    
    init(service: CatsNetworkProviding) {
        self.service = service
    }
}

extension FeedViewModel {
    @MainActor 
    func onAppear() async {
        loadBreedsBatch()
    }

    @MainActor
    func search(for query: String) {
        guard !query.isEmpty else {
            displayedBreeds = allBreeds
            return
        }
        searchTask?.cancel()
        searchTask = Task {
            do {
                try Task.checkCancellation()
                displayedBreeds = try await service.searchBreeds(by: query)
                try await loadImages(for: displayedBreeds)
            } catch { }
        }
    }
    
    @MainActor
    func breedShown(at index: Int) {
        guard index == allBreeds.count - prefetchOffset else { return }
        lastLoadedBreedsPage += 1
        loadBreedsBatch()
    }

    func breedSelected(_ breed: Breed) {
        lastSelectedBreed = breed
    }
}

private extension FeedViewModel {
    @MainActor
    func loadImages(for breeds: [Breed]) async throws {
        for breed in breeds {
            guard let imageID = breed.imageID, breedsImageURLs[breed.id] == nil else { continue }
            let imageURL = try await service.getRandomImage(of: imageID).url
            breedsImageURLs[breed.id] = URL(string: imageURL)
        }
    }
    
    @MainActor
    func loadBreedsBatch() {
        Task {
            do {
                let newBreeds = try await service.getBreeds(page: lastLoadedBreedsPage)
                allBreeds.append(contentsOf: newBreeds)
                displayedBreeds = allBreeds
                try await loadImages(for: newBreeds)
            } catch {
                
            }
        }
    }
}

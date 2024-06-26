//
//  FeedViewModel.swift
//  Cats
//
//  Created by Inna Lytvynenko on 11.03.2024.
//

import Combine
import SwiftUI

final class FeedViewModel: ObservableObject {
    
    enum ErrorState {
        case somethingWentWrong, noSearchResults
    }
    
    @Published var displayedBreeds: [Breed] = []
    @Published var breedsImageURLs: [String: URL] = [:]
    @Published var searchText: String = ""
    @Published var errorState: ErrorState?
    private var allBreeds: [Breed] = []
    private var searchTask: Task<Void, Error>?
    private var pageToLoadIndex = 0
    private var lastSelectedBreed: Breed?
    private let service: CatsNetworkProviding
    private let prefetchOffset = 5
    
    init(service: CatsNetworkProviding) {
        self.service = service
    }
}

extension FeedViewModel {
    @MainActor 
    func onAppear() {
        loadBreedsBatch()
    }
    
    @MainActor
    func refresh() {
        allBreeds = []
        pageToLoadIndex = 0
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
                errorState = displayedBreeds.count == 0 ? .noSearchResults : nil
                try await loadImages(for: displayedBreeds)
            } catch { }
        }
    }
    
    @MainActor
    func breedShown(at index: Int) {
        guard index == allBreeds.count - prefetchOffset else { return }
        loadBreedsBatch()
    }

    func breedSelected(_ breed: Breed) {
        lastSelectedBreed = breed
    }
    
    var breedDetailsViewModel: BreedDetailsViewModel {
        BreedDetailsViewModel(
            breed: lastSelectedBreed!,
            imageURL: breedsImageURLs[lastSelectedBreed!.id],
            service: service
        )
    }
}

private extension FeedViewModel {
    @MainActor
    func loadImages(for breeds: [Breed]) async throws {
        for breed in breeds {
            guard let imageID = breed.imageID, breedsImageURLs[breed.id] == nil else { continue }
            let imageURL = try await service.getImage(of: imageID).url
            breedsImageURLs[breed.id] = URL(string: imageURL)
        }
    }
    
    @MainActor
    func loadBreedsBatch() {
        Task {
            do {
                let newBreeds = try await service.getBreeds(page: pageToLoadIndex)
                allBreeds.append(contentsOf: newBreeds)
                displayedBreeds = allBreeds
                pageToLoadIndex += 1
                try await loadImages(for: newBreeds)
            } catch {
                errorState = displayedBreeds.count == 0 ? .somethingWentWrong : nil
            }
        }
    }
}

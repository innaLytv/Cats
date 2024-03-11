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
    @Published var breedsList: [Breed] = []
    
    init(service: CatsNetworkProviding) {
        self.service = service
    }
}

extension FeedViewModel {
    @MainActor
    func fetchBreeds() async {
        do {
            breedsList = try await service.getAllBreeds(page: 0)
        } catch { }
    }
}

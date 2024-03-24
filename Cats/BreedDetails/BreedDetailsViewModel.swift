//
//  BreedDetailsViewModel.swift
//  Cats
//
//  Created by Inna Lytvynenko on 15.03.2024.
//

import SwiftUI

final class BreedDetailsViewModel: ObservableObject {
    let breed: Breed
    let imageURL: URL?
    private let service: CatsNetworkProviding
    
    init(breed: Breed, imageURL: URL?, service: CatsNetworkProviding) {
        self.breed = breed
        self.imageURL = imageURL
        self.service = service
    }
}

extension BreedDetailsViewModel {
    var temperament: [String] {
        breed.temperament.components(separatedBy: ",")
    }
    
    var breedImageGalleryViewModel: BreedImageGalleryViewModel {
        BreedImageGalleryViewModel(breedId: breed.id, service: service)
    }
}

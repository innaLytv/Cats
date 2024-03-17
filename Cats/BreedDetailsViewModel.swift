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
    
    init(breed: Breed, imageURL: URL?) {
        self.breed = breed
        self.imageURL = imageURL
    }
}

extension BreedDetailsViewModel {
    var temperament: [String] {
        breed.temperament.components(separatedBy: ",")
    }
}

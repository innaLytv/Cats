//
//  Breed.swift
//  Cats
//
//  Created by Inna Lytvynenko on 29.02.2024.
//

struct Breed: Codable, Hashable {
    let name: String
    let imageID: String?

    enum CodingKeys: String, CodingKey {
        case name
        case imageID = "reference_image_id"
    }
}

struct CatImage: Codable {
    let url: String
}

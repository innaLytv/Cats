//
//  Breed.swift
//  Cats
//
//  Created by Inna Lytvynenko on 29.02.2024.
//

struct Breed: Codable, Hashable {
    let name: String
    let imageID: String?
    let temperament: String
    let origin: String
    let description: String
    let lifeSpan: String
    let intelligence: Int
    let childFrienly: Int
    let healthIssues: Int
    let adaptability: Int
    let socialNeeds: Int

    enum CodingKeys: String, CodingKey {
        case name, imageID = "reference_image_id", origin,
             temperament, description, lifeSpan = "life_span",
             intelligence, childFrienly = "child_friendly",
             healthIssues = "health_issues", adaptability,
             socialNeeds = "social_needs"
    }
}

struct CatImage: Codable {
    let url: String
}

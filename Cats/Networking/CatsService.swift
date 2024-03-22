//
//  CatsService.swift
//  Cats
//
//  Created by Inna Lytvynenko on 29.02.2024.
//

import Alamofire

protocol CatsNetworkProviding {
    func getBreeds(page: Int) async throws -> [Breed]
    func searchBreeds(by term: String) async throws -> [Breed]
    func getRandomImage(of breedId: String) async throws -> CatImage
}

struct CatsNetworkProvider: CatsNetworkProviding {
    func getBreeds(page: Int) async throws -> [Breed] {
        let params = [
            "limit": String(Constants.breedsLimit),
            "page": String(page)
        ]
        return try await AF.request(
            requestURL(
                path: "breeds?",
                parameters: params
            )
        )
        .cacheResponse(using: .cache)
        .serializingDecodable([Breed].self)
        .value
    }
    
    func searchBreeds(by term: String) async throws -> [Breed] {
        let params = [
            "q": term
        ]
        return try await AF.request(
            requestURL(
                path: "breeds/search?",
                parameters: params
            )
        )
        .serializingDecodable([Breed].self)
        .value
    }
    
    func getRandomFact(of breedId: String) async throws -> BreedFact {
        let params = [
            "limit": "1",
            "page": "0"
        ]
        return try await AF.request(
            requestURL(
                path: "breeds/:\(breedId)/facts",
                parameters: params
            )
        )
        .serializingDecodable(BreedFact.self)
        .value
    }
    
    func getRandomImage(of breedId: String) async throws -> CatImage {
        let headers: HTTPHeaders = ["x-api-key" : Constants.apiKey]
        return try await AF.request(
            requestURL(
                path: "images/\(breedId)",
                parameters: [:]
            ),
            headers: headers
        )
        .serializingDecodable(CatImage.self)
        .value
    }
}

private extension CatsNetworkProvider {
    func requestURL(path: String, parameters: [String: String]) -> String {
        let parametersString = parameters.reduce("") { resultURL, parameterPair in
            resultURL + parameterPair.key + "=" + parameterPair.value + "&"
        }
            .dropLast()
        return Constants.baseURL + path + parametersString
    }
}

private extension CatsNetworkProvider {
    enum Constants {
        static let baseURL = "https://api.thecatapi.com/v1/"
        static let breedsLimit = 15
        static let apiKey = "live_WbfXqQTprPqn8hxo6kMiffwWgxN74tJ6k4ZL4p4He6HnlTHGZMMDQ430DTSMRfcS"
    }
}

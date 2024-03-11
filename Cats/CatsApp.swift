//
//  CatsApp.swift
//  Cats
//
//  Created by Inna Lytvynenko on 25.02.2024.
//

import SwiftUI

@main
struct CatsApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView(
                viewModel: FeedViewModel(
                    service: CatsNetworkProvider()
                )
            )
        }
    }
}

//
//  ContentView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 25.02.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
        .onAppear {
            let service = CatsNetworkProvider()
            Task {
                let breeds = try! await service.searchBreed(by: "air")
                print(breeds)
            }
        }
    }
}

#Preview {
    ContentView()
}

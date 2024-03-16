//
//  BreedDetailsView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 15.03.2024.
//

import Foundation

import SwiftUI

struct BreedDetailsView: View {
    @ObservedObject private var viewModel: BreedDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: BreedDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
    }
}

//
//  BreedFeatureView.swift
//  Cats
//
//  Created by Inna Lytvynenko on 17.03.2024.
//

import SwiftUI

struct BreedFeatureView: View {
    private let filledPointsCount: Int
    private let title: String
    
    init(filledPointsCount: Int, title: String) {
        self.filledPointsCount = filledPointsCount
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                Spacer()
            }
            HStack {
                ForEach(
                    0...(Constants.pointsNumber - 1),
                    id: \.self
                ) { pointIndex in
                    Image(
                        systemName: pointIndex < filledPointsCount ? Constants.filledImageName : Constants.unfilledImageName
                    )
                    if pointIndex != (Constants.pointsNumber - 1) {
                        Image(systemName: "minus")
                    }
                }
                Spacer()
            }
            .foregroundStyle(
                Color(
                    uiColor:
                        UIColor(
                            red: 159 / 255,
                            green: 199 / 255,
                            blue: 224 / 255,
                            alpha: 1
                        )
                )
            )
        }
    }
}

private extension BreedFeatureView {
    enum Constants {
        static let pointsNumber = 5
        static let filledImageName = "circlebadge.fill"
        static let unfilledImageName = "circlebadge"
    }
}


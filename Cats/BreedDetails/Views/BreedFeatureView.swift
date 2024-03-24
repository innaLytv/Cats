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
        VStack(spacing: Constants.verticalSpacing) {
            HStack {
                Text(title)
                Spacer()
            }
            pointImagesStack
        }
    }
}

private extension BreedFeatureView {
    var pointImagesStack: some View {
        HStack {
            ForEach(
                0...Constants.pointsLastIndex,
                id: \.self
            ) { pointIndex in
                Image(
                    systemName: pointIndex < filledPointsCount ? Constants.filledImageName : Constants.unfilledImageName
                )
                if pointIndex != Constants.pointsLastIndex {
                    Image(systemName: Constants.pointSeparatorImageName)
                }
            }
            Spacer()
        }
        .foregroundStyle(
            Color(Constants.foregroundColor)
        )
    }
}

private extension BreedFeatureView {
    enum Constants {
        static let verticalSpacing = 10.0
        static let pointsLastIndex = 4
        static let filledImageName = "circlebadge.fill"
        static let unfilledImageName = "circlebadge"
        static let pointSeparatorImageName = "minus"
        static let foregroundColor = UIColor(r: 159, g: 199, b: 224, a: 1)
    }
}


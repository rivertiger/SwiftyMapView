//
//  PinAnnotationView.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation
import SwiftUI

struct PinAnnotationView: View {
    @ObservedObject var viewModel: MapViewModel
    @State private var showDistances = true
    let title: String
    let pinId: String
    let closestPoints: [String]

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.callout)
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)

            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)

            ForEach(closestPoints, id: \.self) { displayName in
                Text(displayName)
                .font(.callout)
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
                .opacity(1)
            }
        }
        .onTapGesture {
            viewModel.calculateHaversineOfClosestPoints(for: pinId)
            showDistances = true
        }
    }
}

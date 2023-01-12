//
//  FeatureCollection.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation

 protocol FeatureCollectionDescribing: Codable {
    var type: String? { get set }
    var features: [Feature]? { get set }
}

struct FeatureCollection: FeatureCollectionDescribing {

    var type: String?
    var features: [Feature]?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case features = "features"
    }
}


func distanceInMilesBetweenEarthCoordinates(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {

    let radius: Double = 3959.0 // Miles
    let deltaP = (lat1.degreesToRadians - lat2.degreesToRadians)
    let deltaL = (lon1.degreesToRadians - lon2.degreesToRadians)
    let a = sin(deltaP/2) * sin(deltaP/2) + cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) * sin(deltaL/2) * sin(deltaL/2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))
    let d = radius * c
    return d
}

extension Double {
    var degreesToRadians: Double {
        return self * Double.pi / 180
    }
}

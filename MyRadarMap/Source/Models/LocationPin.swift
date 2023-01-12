//
//  LocationPin.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation
import MapKit

protocol LocationPinDescribing {
    var pinName: String { get set }
    var pinId: String { get set }
    var coordinate: CLLocationCoordinate2D { get set }
    var haversineDistance: Double { get set }
    var closestPoints: [String] { get set }

    func assignFirstThree(closest pins: [String])
}

extension LocationPinDescribing {
    func formatPinForDisplay(with pins: [LocationPinDescribing]) -> [String] {
        var result:[String] = []
        for eachPin in pins {
            let text = eachPin.pinName + ":" + String(round(eachPin.haversineDistance * 100) / 100.0)
            result.append(text)
        }
        return result
    }
}

class LocationPin: NSObject, Identifiable, LocationPinDescribing, MKAnnotation {

    enum Constants {
        static let defaultLat = 0.0
        static let defaultLong = 0.0
        static let noName = "No Title"
    }

    //comparison distance against reference
    var haversineDistance: Double = 0.0
    //store the (3) closest pins
    var closestPoints: [String] = []

    var pinName: String
    var pinId: String
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Constants.defaultLat, longitude: Constants.defaultLong)
    let id = UUID()

    init(feature: FeatureDescribing) {
        self.pinName = feature.properties?.name ?? "No Title"
        self.pinId = feature.id ?? "UNKNOWN"

        guard let lat = feature.geometry?.coordinates[0],
              let long = feature.geometry?.coordinates[1]
               else { return }
        coordinate = CLLocationCoordinate2DMake(lat, long)
    }

    func assignFirstThree(closest pins: [String]) {
        closestPoints = pins
    }
}

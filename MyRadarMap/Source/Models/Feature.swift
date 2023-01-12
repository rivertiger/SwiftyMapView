//
//  Feature.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation

protocol GeometryDescribing: Codable {
    var type: String? { get set }
    var coordinates: [Double] { get set }
}

struct Geometry: GeometryDescribing {
    var type: String?
    var coordinates: [Double]

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case coordinates = "coordinates"
    }
}

protocol PropertyDescribing: Codable {
    var name: String? { get set }
}

struct Properties: PropertyDescribing {
    var name: String?
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

protocol FeatureDescribing: Codable {
    var type: String? { get set }
    var id: String? { get set }
    var geometry: Geometry? { get set }
    var properties: Properties? { get set }
}

struct Feature: FeatureDescribing {

    var type: String?
    var id: String?
    var geometry: Geometry?
    var properties: Properties?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case geometry = "geometry"
        case properties = "properties"
    }
}

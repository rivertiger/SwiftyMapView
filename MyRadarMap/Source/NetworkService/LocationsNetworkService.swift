//
//  LocationsNetworkService.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation
import Combine

protocol LocationsNetworkServicing {
    func fetchLocations(completionHandler: @escaping (Result<FeatureCollection, CustomError>) -> Void)
}

struct LocationsNetworkService: LocationsNetworkServicing {
    private var networkService: NetworkServicing

    private enum Constants {
        static let locationsUrl = "https://assets.acmeaom.com/interview-project/locations.json"
    }

    init(networkService: NetworkServicing = NetworkService(urlSession: URLSession.shared)) {
        self.networkService = networkService
    }

    func fetchLocations(completionHandler: @escaping (Result<FeatureCollection, CustomError>) -> Void) {
        networkService.makeRequest(endpoint: Constants.locationsUrl) { (result: Result<FeatureCollection, CustomError>) in
            completionHandler(result)
        }
    }

    //Alternate Using Combine
    func fetchLocationsFromPublisher() -> AnyPublisher<FeatureCollection, CustomError> {
        return networkService.makeRequestWithPublisher(endpoint: Constants.locationsUrl)
            .eraseToAnyPublisher()
    }
}

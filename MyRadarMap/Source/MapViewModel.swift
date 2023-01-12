import Foundation
import Combine

@MainActor class MapViewModel: ObservableObject {

    @Published var featureModels: [Feature] = []
    @Published var mapPins: [LocationPin] = []
    @Published var publishedError: CustomError?
    @Published var publishedClosestPoints: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []

    //
    public func calculateHaversineOfClosestPoints(for pinID: String) {

        guard let source = self.mapPins.first(where: { $0.pinId == pinID }) else { return }
        source.haversineDistance = 0.0 //clear the sourceReference

        let allOthers = self.mapPins.filter({ ![source].contains($0) })
        for each in allOthers {
            let dist = distanceInMilesBetweenEarthCoordinates(lat1: source.coordinate.latitude, lon1: source.coordinate.longitude, lat2: each.coordinate.latitude, lon2: each.coordinate.longitude)
            each.haversineDistance = dist
        }
        //sort by highest value
        let sorted = allOthers.sorted(by: { $0.haversineDistance < $1.haversineDistance })
        for each in sorted {
            print("Pin Name:\(each.pinName) , haversine distance: \(each.haversineDistance)")
        }

        let firstThree = source.formatPinForDisplay(with: Array(sorted.prefix(3)))
        source.assignFirstThree(closest: firstThree)
        publishedClosestPoints = true
    }


    public func fetchGeoObjects() {
        let networkService = LocationsNetworkService()
        networkService.fetchLocations { result in
            DispatchQueue.main.sync {
                switch result {
                case .success(let model):
                    self.featureModels = model.features ?? []
                    self.mapPins = self.generateLocationPins(from: model.features)
                    break
                case .failure(let error):
                    self.publishedError = error
                    break
                }
            }
        }
    }

    public func fetchGeoObjectsFromPublisher() {
        sendRequest()
        .receive(on: RunLoop.main)
        .sink { _ in
        } receiveValue: { value in
            self.featureModels = value.features ?? []
            self.mapPins = self.generateLocationPins(from: value.features)
        }
        .store(in: &cancellables)
    }

    private func sendRequest() -> AnyPublisher<FeatureCollection, CustomError> {
        let networkService = LocationsNetworkService()
        return networkService.fetchLocationsFromPublisher()
            .eraseToAnyPublisher()
    }

    private func generateLocationPins(from features: [FeatureDescribing]?) -> [LocationPin] {
        let arrOfPins = features.map { features -> [LocationPin] in
            var array:[LocationPin] = []
            for each in features {
                let pin = LocationPin(feature: each)
                array.append(pin)
            }
            return array
        }
        return arrOfPins ?? []
    }
}

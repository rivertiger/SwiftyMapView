import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.828, longitude: -98.579),
        span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0)
    )
    enum Constants {
        static let cupertinoLat: Double = 37.3230
        static let cupertinoLong: Double = 122.0322
        static let defaultPin = CLLocationCoordinate2D(latitude: Constants.cupertinoLat, longitude: Constants.cupertinoLong)
    }


    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        VStack{
            Text("Fetch Pins")
                .font(.system(size: 15))
            Button(action: {
                print("Button is pressed")
//                viewModel.fetchGeoObjectsFromPublisher() //UNCOMMENT TO USE ALTERNATE COMBINE
                viewModel.fetchGeoObjects()
            }) {
                Text("Press me")
                    .padding()
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Color.blue)
            }
            Text("PinCount is:\(viewModel.mapPins.count)")
            Text("Count is:\(viewModel.featureModels.count)")
            Map(coordinateRegion: $region, annotationItems:viewModel.mapPins ) { pin in
                MapAnnotation(coordinate: pin.coordinate) {
                    PinAnnotationView(viewModel: viewModel, title: pin.pinName, pinId: pin.pinId, closestPoints: pin.closestPoints)
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

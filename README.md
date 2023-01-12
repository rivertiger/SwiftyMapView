# iOS Assessment Project

## Delivery

**Do not fork this repo.** You should have been invited as a private contributor to this repo so you can push changes directly to it. Please ensure you have write permissions and let us know if you have issues. Please send us an email informing us that it's ready to review.

## Overview

You will create an app to ingest location data via HTTP encoded in [GeoJSON format](https://geojson.org), display the locations on a map as annotations/markers, and allow users to view information about them.

Your work is evaluated based on the following:

1. Overall software design.
2. Code quality.
3. Conformity to requirements.

## Getting Started

> Note: You'll need to change the bundle identifier to something else.

The template project contains the following:

- `MyRadarMapApp` - App which contains a scene that uses `MapView`.
- `MapView` - The primary view which contains a `Map`.
- `MapViewModel` - Empty view model for `MapView`.
- `MapViewModelTest` - Empty test for `MapViewModel`.

> Important: The location and names of these files should not change; organize any new files you add to the project as you see fit.

## Requirements

- Ingest GeoJSON from the URL mentioned in [Resources](#resources) and render these markers on the map view when the app starts or resumes.
- Annotations on the map should be identified by their name.
- A single tap on a marker should present the three nearest annotations/markers.
- The markers should be represented by their location name and distance (in miles) to the tapped marker. Precision: two decimal places. Sorted: ascending by distance.
- Distances should be calculated using the [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula).
- Handle network failure conditions, inform the user of failures and allow them to retry the request.

### Constraints / Design Requirements

- Use Swift.
- Use SwiftUI.
- Use a Combine pipeline for fetching GeoJSON, decoding the result, and binding the output to the view.
- Use the MVVM design pattern for views that contain view logic.
- Use Git.
- No third-party dependencies or code other than those included in the template project.
- No beta APIs.

### Testing Requirements

- Unit tests are required.
- 100% code coverage is **not** required.
- UI tests are not required and should not be created.

## <a name="resources"></a>External Resources

Please use this endpoint which returns a GeoJSON `FeatureCollection`: [https://assets.acmeaom.com/interview-project/locations.json](https://assets.acmeaom.com/interview-project/locations.json)

The GeoJSON content will always be a feature collection of features, with each feature having a geometry type of `Point`, a `name` property, and a unique `ID`.

### Example Feature from GeoJSON

```javascript
  {
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [
        -67.09898354941409,
        45.042099781891125
      ]
    },
    "properties": {
      "name": "NAME"
    },
    "id": "UNIQUE_STRING"
  }
```

## Assumptions

- Custom-designed assets are not necessary.
- Data persistence is not necessary.

## License

By delivering your completed project to us, you grant us a license to use the code exclusively to review/evaluate your work.

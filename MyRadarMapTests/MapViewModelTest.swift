import XCTest
import Combine
import Foundation

@testable import MyRadarMap

/// Test for `MapViewModel` behavior.
final class MapViewModelTest: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var urlSession: URLSessionMock!
    private var sut: NetworkServicing!
    private var url: URL!
    private let testTimestamp = "Mon, 1 Feb 2021 18:53:42 GMT"
    private var endpoint: String = "https://www.google.com/"

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = Set<AnyCancellable>()
        urlSession = URLSessionMock()
        url = URL(string: "https://www.google.com/")
        sut = NetworkService(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        cancellables = nil
        urlSession = nil
        url = nil
        sut = nil
    }

    func readLocalFileFromModule(filename name: String) -> Data? {
        do {
            let testBundle = Bundle(for: type(of: self))
            guard let ressourceURL = testBundle.url(forResource: "testData", withExtension: "json")?.path else { return nil }

                let json = try? String(contentsOfFile: ressourceURL)
                print(json)
            let jsonAsData = json?.data(using: .utf8)
                return jsonAsData
            } catch {
            print(error)
        }
    }

    func test_makeRequestReturnsSuccess() {

        let expectation = XCTestExpectation(description: "Testing NetworkService.MakeRequest")

        urlSession.data = readLocalFileFromModule(filename: "testData.json")!
        urlSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Date": testTimestamp])

        var fetchedCollection: FeatureCollection?

        sut.makeRequest(endpoint: endpoint) { (result: Result<FeatureCollection, CustomError>) in
            switch result {
            case .success(let model):
                fetchedCollection = model
                break
            case .failure(_):
                XCTFail("Should not have failed.")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(fetchedCollection)
        guard let collection = fetchedCollection?.features else { return }
        XCTAssertTrue(collection.count > 0)
    }


    func test_makeRequestPublisherReturnsSuccess() {

        let expectation = XCTestExpectation(description: "Testing NetworkService.MakeRequestWithPublisher")

        urlSession.data = readLocalFileFromModule(filename: "testData.json")!
        urlSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Date": testTimestamp])

        var fetchedCollection: FeatureCollection?

            testRequest()
            .sink { _ in
            } receiveValue: { value in
                fetchedCollection = value
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(fetchedCollection)
        guard let collection = fetchedCollection?.features else { return }
        XCTAssertTrue(collection.count > 0)
    }

    private func testRequest() -> AnyPublisher<FeatureCollection, CustomError> {
        sut.makeRequestWithPublisher(endpoint: endpoint)
            .eraseToAnyPublisher()
    }
}



//
//  NetworkService.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/14/22.
//

import Foundation
import Combine

public enum EndpointType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}


public protocol NetworkServicing {

    func makeRequest<T>(endpoint: String, completion: @escaping (Result<T, CustomError>) -> Void) where T: Decodable

    //Alternate Using Combine
    func makeRequestWithPublisher<T>(endpoint: String) -> AnyPublisher<T, CustomError> where T: Decodable
}

public struct NetworkService: NetworkServicing {

    private let urlSession: URLSession
    private let responseProcessor: NetworkResponseProcessing

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
        self.responseProcessor = ResponseProcessor()
    }

    public func makeRequest<T: Decodable>(endpoint: String, completion: @escaping (Result<T, CustomError>) -> Void) {


        guard let request = urlRequest(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        urlSession
            .dataTask(with: request) { data, response, error in
                completion(self.responseProcessor.processResponse(data: data, response: response, error: error))
            }
            .resume()
    }

    //Alternate Using Combine
    public func makeRequestWithPublisher<T>(endpoint: String) -> AnyPublisher<T, CustomError> where T : Decodable {

        guard let request = urlRequest(for: endpoint) else {
            return Fail(error: CustomError.invalidURL).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: request)
            .tryMap({ result in

                let processedResponse: Result<T, CustomError> = self.responseProcessor.processResponse(data: result.data, response: result.response, error: nil)
                switch processedResponse {
                case .success(let model):
                    return model
                case .failure(let error):
                    throw error
                }
            })
            .mapError { $0 as? CustomError ?? .unknownError }
            .eraseToAnyPublisher()
    }

    private func urlRequest(for endpoint: String) -> URLRequest? {
        guard let url = URL(string: endpoint) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = EndpointType.get.rawValue
        request.cachePolicy = .reloadIgnoringCacheData
        return request
    }
}



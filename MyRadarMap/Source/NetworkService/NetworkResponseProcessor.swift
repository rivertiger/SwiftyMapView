//
//  NetworkResponseProcessor.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation

protocol NetworkResponseProcessing {

    func processResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, CustomError>
}

final class ResponseProcessor: NetworkResponseProcessing {

    init() { }

    func processResponse<T>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, CustomError> where T : Decodable {
        guard error == nil,
              let response = response as? HTTPURLResponse
        else {
            return .failure(.unknownError)
        }

        if !(200 ... 299).contains(response.statusCode),
           let _ = response.url?.absoluteString
        {
            //log error
        }

        switch response.statusCode {
        case 200 ..< 299:
            if let data = data, let model = try? JSONDecoder().decode(T.self, from: data) {
                return .success(model)
            } else {
                return .failure(.noData)
            }
        case 400 ..< 499:
            return .failure(.unauthorized)
        default:
            return .failure(.unknownError)
        }
    }
}

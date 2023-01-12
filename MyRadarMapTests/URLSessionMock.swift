//
//  URLSessionMock.swift
//  MyRadarMapTests
//
//  Created by James Nguyen on 12/15/22.
//

import Foundation



// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var response: URLResponse?

    override init() {
        super.init()
    }

    init(configuration _: URLSessionConfiguration) {
        super.init()
    }

    var timestamp: String?

    override func dataTask(
        with _: URLRequest,
        completionHandler: @escaping CompletionHandler) -> URLSessionDataTask
    {
        let data = self.data
        let error = self.error
        let response = self.response
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }

    override func dataTask(
        with _: URL,
        completionHandler: @escaping CompletionHandler) -> URLSessionDataTask
    {
        let data = self.data
        let error = self.error
        let response = self.response
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

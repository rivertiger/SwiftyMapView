//
//  NetworkServicing.swift
//  MyRadarMap
//
//  Created by James Nguyen on 12/14/22.
//

import Foundation
import Combine

public enum CustomError: Error, Equatable {
    case invalidURL
    case parsingError
    case unknownError
    case noData
    case unauthorized
}

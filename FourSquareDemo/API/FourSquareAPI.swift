//
//  FourSquareAPI.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Combine
import Foundation

enum FourSquareAPI {
    // MARK: Internal

    static func places(lat: Double, long: Double, radius: Double = Constants.radius) -> AnyPublisher<PlacesResponse, Error> {
        let request = URLComponents(url: AppEnvironment.baseURL.appendingPathComponent("v2/venues/search"), resolvingAgainstBaseURL: true)?
            .addingQueryItem("ll", "\(lat),\(long)")
            .addingQueryItem("radius", "\(radius)")
            .addingQueryItem("limit", Constants.requestLimit)
            .addingQueryItem("v", Constants.requestDate)
            .withAuthentication()
            .request
        return runner.run(request!)
    }

    // MARK: Private

    private static let runner = Runner()
}

extension URLComponents {
    func addingQueryItem(_ name: String, _ value: String) -> URLComponents {
        var copy = self
        copy.queryItems = (copy.queryItems ?? []) + [URLQueryItem(name: name, value: value)]
        return copy
    }

    func withAuthentication() -> URLComponents {
        var copy = self
        copy.queryItems = (copy.queryItems ?? []) + [
            URLQueryItem(name: "client_id", value: AppEnvironment.clientID),
            URLQueryItem(name: "client_secret", value: AppEnvironment.clientSecret)
        ]
        return copy
    }

    var request: URLRequest? {
        url.map { URLRequest(url: $0) }
    }
}

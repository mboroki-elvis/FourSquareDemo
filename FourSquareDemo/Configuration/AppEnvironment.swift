//
//  AppEnvironment.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Foundation

enum AppEnvironment {
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        debugPrint(dictionary)
        return dictionary
    }()

    static let baseURLString: String = {
        guard let baseURLString = AppEnvironment.infoDictionary["BASE_URL"] as? String else {
            fatalError("Base URL not set in the plist for this environment")
        }
        return baseURLString
    }()

    static let baseURL: URL = {
        guard let baseURL = URL(string: baseURLString) else {
            fatalError("Couldn't conver base url string to URL")
        }
        return baseURL
    }()

    static let clientID: String = {
        guard let clientID = AppEnvironment.infoDictionary["CLIENT_ID"] as? String else {
            fatalError("Client ID is not set in the plist for this environment")
        }

        return clientID
    }()
    
    static let clientSecret: String = {
        guard let clientSecret = AppEnvironment.infoDictionary["CLIENT_SECRET"] as? String else {
            fatalError("Client Secret is not set in the plist for this environment")
        }

        return clientSecret
    }()
}

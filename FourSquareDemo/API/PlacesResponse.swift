//
//  PlacesResponse.swift
//  FourSquareDemo
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import Foundation

// MARK: - PlacesResponse

struct PlacesResponse: Decodable {
    let meta: Meta
    let response: VenueResponse
}

// MARK: - Meta

struct Meta: Decodable {
    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }

    let code: Int
    let requestID: String
}

// MARK: - VenueResponse

struct VenueResponse: Decodable {
    let venues: [Venue]
}

// MARK: - Venue

struct Venue: Decodable {
    let id, name: String
    let location: Location
    let categories: [Category]
}

// MARK: - Category

struct Category: Decodable {
    let id, name, pluralName, shortName: String
    let icon: Icon
    let primary: Bool
}

// MARK: - Icon

struct Icon: Decodable {
    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }

    let iconPrefix: String
    let suffix: String

    var iconPath: URL? { URL(string: iconPrefix + "88" + suffix) }
}

// MARK: - Location

struct Location: Decodable {
    var address, crossStreet: String?
    let lat, lng: Double
    let labeledLatLngs: [LabeledLatLng]
    let distance: Int
    let postalCode, cc, city, state: String
    let country: String
    let formattedAddress: [String]
}

// MARK: - LabeledLatLng

struct LabeledLatLng: Decodable {
    let label: String
    let lat, lng: Double
}

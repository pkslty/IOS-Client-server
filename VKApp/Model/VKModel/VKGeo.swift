//
//  VKGeo.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKGeo: Decodable {
    let placeId: Int
    let title: String
    let type: String
    let countryId: Int
    let cityId: Int
    let address: String
    let showMap: Bool
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case title
        case type
        case countryId = "country_id"
        case cityId = "city_id"
        case address
        case showMap = "showmap"
    }
}

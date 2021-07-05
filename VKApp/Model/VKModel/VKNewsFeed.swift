//
//  VKNewsFeed.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKNewsFeed: Decodable {
    let items: [VKNew]
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items
        case nextFrom = "next_from"
    }
}

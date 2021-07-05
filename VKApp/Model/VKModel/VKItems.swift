//
//  VKItems.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.05.2021.
//

import Foundation

struct VKItems<T: Decodable>: Decodable {
    let count: Int
    let items: [T]
    
    enum CodingKeys: String, CodingKey {
        case count
        case items
    }
}

//
//  VKImage.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKImage: Decodable {
    let height: Int
    let url: String
    let width: Int
    let withPadding: Int?
    
    enum CodingKeys: String, CodingKey {
        case height
        case url
        case width
        case withPadding = "with_padding"
    }
}

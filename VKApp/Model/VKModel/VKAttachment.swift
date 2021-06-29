//
//  VKAttachment.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKAttachment: Decodable {
    let type: String
    let photo: VKPhoto?
    let video: VKVideo?
    let link: VKLink?
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo
        case video
        case link
    }
}

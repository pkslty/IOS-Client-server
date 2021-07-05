//
//  VKNote.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKNote: Decodable {
    let id: Int
    let ownerId: Int
    let title: String
    let comments: VKComments
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case title
        case comments
    }
}

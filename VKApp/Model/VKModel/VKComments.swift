//
//  VKComments.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKComments: Decodable {
    let count: Int
    let canPost: Bool
    let groupsCanPost: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try values.decode(Int.self, forKey: .count)
        self.canPost = try values.decode(Int.self, forKey: .canPost) == 1 ? true : false
        self.groupsCanPost = try values.decode(Int.self, forKey: .groupsCanPost) == 1 ? true : false
    }
    
}

/*
 comments": {
 "count": 0,
 "can_post": 1,
 "groups_can_post": true
 }
 */

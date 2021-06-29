//
//  VKLikes.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKLikes: Decodable {
    let count: Int
    let userLikes: Bool
    let canLike: Bool
    let canPublish: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try values.decode(Int.self, forKey: .count)
        self.userLikes = try values.decode(Int.self, forKey: .userLikes) == 1 ? true : false
        self.canLike = try values.decode(Int.self, forKey: .canLike) == 1 ? true : false
        self.canPublish = try values.decode(Int.self, forKey: .canPublish) == 1 ? true : false
    }
    
}

    

/*
 "likes": {
 "count": 2,
 "user_likes": 0,
 "can_like": 1,
 "can_publish": 1
 }
 */

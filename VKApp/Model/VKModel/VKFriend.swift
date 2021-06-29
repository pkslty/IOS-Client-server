//
//  VKFriend.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKFriend: Decodable {
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}

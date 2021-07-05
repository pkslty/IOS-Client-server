//
//  VKReposts.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKReposts: Decodable {
    let count: Int
    let userReposted: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try values.decode(Int.self, forKey: .count)
        self.userReposted = try values.decode(Int.self, forKey: .userReposted) == 1 ? true : false
    }
    
}

/*
 "reposts": {
 "count": 0,
 "user_reposted": 0
 }
 */

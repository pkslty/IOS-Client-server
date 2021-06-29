//
//  VKGroup.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.05.2021.
//

import Foundation

struct VKGroup: Decodable {
    let id: Int
    let name: String
    let screenName: String
    let isClosed: Int
    let type: String
    let isAdmin: Int
    let isMember: Int
    let isAdvertiser: Int
    let photo50UrlString: String?
    let photo100UrlString: String?
    let photo200UrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50UrlString = "photo_50"
        case photo100UrlString = "photo_100"
        case photo200UrlString = "photo_200"
    }
}
/*
 {
                 "id": 15365973,
                 "name": "GeekBrains",
                 "screen_name": "geekbrainsru",
                 "is_closed": 0,
                 "type": "page",
                 "is_admin": 0,
                 "is_member": 1,
                 "is_advertiser": 0,
                 "photo_50": "https://sun3-11.userapi.com/s/v1/ig2/hO-49ZPTI86i-fYovkLc0KJNKS3p9bcG8PZmwnf_XiHLOD0AxECNkfVnb223hKj-d2OqSkBnxw7jphq-ZTqBpetG.jpg?size=50x0&quality=95&crop=256,256,2046,2046&ava=1",
                 "photo_100": "https://sun3-11.userapi.com/s/v1/ig2/zc27aJwUre7hwFt2qE7pwjE2EIRluFC36SqYoDd_aEcaLB-7UT4M3MgjsYj-q9XL3eIstfzEqi2l-YCepMeIN4H1.jpg?size=100x0&quality=95&crop=256,256,2046,2046&ava=1",
                 "photo_200": "https://sun3-11.userapi.com/s/v1/ig2/So8-QHkrF_tDNwxD-m3B4-weiYbwwN2OCcVk5yDWSMeUHrwSs8OUf1Mb3lbbFxShjXvHxHxESloz3-1x6Q8QvrHU.jpg?size=200x0&quality=95&crop=256,256,2046,2046&ava=1"
             }
 */

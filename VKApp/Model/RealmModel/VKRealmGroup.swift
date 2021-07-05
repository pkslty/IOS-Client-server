//
//  VKRealmGroup.swift
//  VKApp
//
//  Created by Denis Kuzmin on 02.06.2021.
//

import Foundation
import RealmSwift

class VKRealmGroup: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = String()
    @objc dynamic var screenName = String()
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var type = String()
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var isAdvertiser: Int = 0
    @objc dynamic var photo50UrlString = String()
    @objc dynamic var photo100UrlString = String()
    @objc dynamic var photo200UrlString =  String()
    
    override static func primaryKey() -> String? {
        "id"
    }
    
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



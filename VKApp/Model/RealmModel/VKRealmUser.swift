//
//  VKRealmUser.swift
//  VKApp
//
//  Created by Denis Kuzmin on 02.06.2021.
//

import Foundation
import RealmSwift

class VKRealmUser: Object, Decodable {
    @objc dynamic var firstName = String()
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName = String()
    @objc dynamic var nickName = String()
    @objc dynamic var avatarUrlString = String()
    var fullName: String {"\(firstName) \(lastName)"}
    
    override static func primaryKey() -> String? {
        "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case nickName = "nickname"
        case avatarUrlString = "photo_200_orig"
    }
}

extension VKRealmUser: Comparable {
    static func < (lhs: VKRealmUser, rhs: VKRealmUser) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    static func == (lhs: VKRealmUser, rhs: VKRealmUser) -> Bool {
        lhs.fullName == rhs.fullName
    }
    
    
}

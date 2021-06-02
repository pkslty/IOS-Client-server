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
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case nickName = "nickname"
        case avatarUrlString = "photo_200_orig"
    }
}

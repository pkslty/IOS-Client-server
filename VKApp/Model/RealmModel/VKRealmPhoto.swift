//
//  VKRealmPhoto.swift
//  VKApp
//
//  Created by Denis Kuzmin on 02.06.2021.
//

import Foundation
import RealmSwift

class VKRealmPhoto: Object, Decodable {
    @objc dynamic var albumId: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var hasTags: Bool = false
    var sizes = List<VKRealmPhotoSize>()
    
    enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case date
        case id
        case ownerId = "owner_id"
        case hasTags = "has_tags"
        case sizes
    }
    
}

class VKRealmPhotoSize: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var urlString = String()
    @objc dynamic var type = String()
    @objc dynamic var width: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case height
        case urlString = "url"
        case type
        case width
    }
}

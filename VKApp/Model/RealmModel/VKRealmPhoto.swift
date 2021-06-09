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
    @objc dynamic var text = String()
    @objc dynamic var userLike: Bool = false
    @objc dynamic var likes: Int = 0
    @objc dynamic var reposts: Int = 0
    @objc dynamic var imageUrlString: String?
    
    override static func primaryKey() -> String? {
        "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case date
        case id
        case ownerId = "owner_id"
        case hasTags = "has_tags"
        case sizes
        case text
        case likes
        case reposts
    }
    enum LikesCodingKeys: String, CodingKey {
        case userLike = "user_likes"
        case count
    }
    enum RepostsCodingKeys: String, CodingKey {
        case count
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        print(values)
        self.albumId = try values.decode(Int.self, forKey: .albumId)
        print(self.albumId)
        self.date = try values.decode(Int.self, forKey: .date)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        self.hasTags = try values.decode(Bool.self, forKey: .hasTags)
        self.sizes = try values.decode(List<VKRealmPhotoSize>.self, forKey: .sizes)
        self.imageUrlString = sizes.first { photoSize in
            photoSize.width > 400
        }?.urlString
        self.text = try values.decode(String.self, forKey: CodingKeys.text)
        let likes = try values.nestedContainer(keyedBy: LikesCodingKeys.self, forKey: .likes)
        self.userLike = try likes.decode(Int.self, forKey: .userLike) == 1 ? true : false
        self.likes = try likes.decode(Int.self, forKey: .count)
        let reposts = try values.nestedContainer(keyedBy: RepostsCodingKeys.self, forKey: .reposts)
        self.reposts = try reposts.decode(Int.self, forKey: .count)
        
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



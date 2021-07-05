//
//  VKVideo.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKVideo: Decodable {
    let id: Int
    let ownerId: Int
    let title: String
    let description: String?
    let duration: Double?
    let image: [VKImage]?
    let firstFrame: [VKImage]?
    let date: Double
    let addingDate: Double?
    let views: Int
    let localViews: Int?
    let comments: Int?
    let player: String?
    let platform: String?
    let canAdd: Bool?
    let isPrivate: Bool?
    let accessKey: String?
    let processing: Bool?
    let isFavorite: Bool?
    let canComment: Bool?
    let canEdit: Bool?
    let canLike: Bool?
    let canRepost: Bool?
    let canSubscribe: Bool?
    let canAddToFaves: Bool?
    let canAttachLink: Bool?
    let width: Int?
    let height: Int?
    let userId: Int?
    let converting: Bool?
    let added: Bool?
    let isSubscribed: Bool?
    //let repeat: Bool?
    let type: String
    let likes: VKLikes?
    let reposts: VKReposts?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case title
        case description
        case duration
        case image
        case firstFrame = "first_frame"
        case date
        case addingDate = "adding_date"
        case views
        case localViews = "local_views"
        case comments
        case player
        case platform
        case canAdd = "can_add"
        case isPrivate = "is_private"
        case accessKey = "access_key"
        case processing
        case isFavorite = "is_favorite"
        case canComment = "can_comment"
        case canEdit = "can_edit"
        case canLike = "can_like"
        case canRepost = "can_repost"
        case canSubscribe = "can_subscribe"
        case canAddToFaves = "can_add_to_faves"
        case canAttachLink = "can_attach_link"
        case width
        case height
        case userId = "user_id"
        case converting
        case added
        case isSubscribed = "is_subscribed"
        //case repeat: Bool?
        case type
        case likes
        case reposts
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try? values.decode(String.self, forKey: .description)
        self.duration = try? values.decode(Double.self, forKey: .duration)
        self.image = try? values.decode([VKImage].self, forKey: .image)
        self.firstFrame = try? values.decode([VKImage].self, forKey: .firstFrame)
        self.date = try values.decode(Double.self, forKey: .date)
        self.addingDate = try? values.decode(Double.self, forKey: .addingDate)
        self.views = try values.decode(Int.self, forKey: .views)
        self.localViews = try? values.decode(Int.self, forKey: .localViews)
        self.comments = try? values.decode(Int.self, forKey: .comments)
        self.player = try? values.decode(String.self, forKey: .player)
        self.platform = try? values.decode(String.self, forKey: .platform)
        self.canAdd = try? values.decode(Int.self, forKey: .canAdd) == 1 ? true : false
        self.isPrivate = try? values.decode(Int.self, forKey: .isPrivate) == 1 ? true : false
        self.accessKey = try? values.decode(String.self, forKey: .accessKey)
        self.processing = try? values.decode(Int.self, forKey: .processing) == 1 ? true : false
        self.isFavorite = try? values.decode(Int.self, forKey: .isFavorite) == 1 ? true : false
        self.canComment = try? values.decode(Int.self, forKey: .canComment) == 1 ? true : false
        self.canEdit = try? values.decode(Int.self, forKey: .canEdit) == 1 ? true : false
        self.canLike = try? values.decode(Int.self, forKey: .canLike) == 1 ? true : false
        self.canRepost = try? values.decode(Int.self, forKey: .canRepost) == 1 ? true : false
        self.canSubscribe = try? values.decode(Int.self, forKey: .canSubscribe) == 1 ? true : false
        self.canAddToFaves = try? values.decode(Int.self, forKey: .canAddToFaves) == 1 ? true : false
        self.canAttachLink = try? values.decode(Int.self, forKey: .canAttachLink) == 1 ? true : false
        self.width = try? values.decode(Int.self, forKey: .width)
        self.height = try? values.decode(Int.self, forKey: .height)
        self.userId = try? values.decode(Int.self, forKey: .userId)
        self.converting = try? values.decode(Int.self, forKey: .converting) == 1 ? true : false
        self.added = try? values.decode(Int.self, forKey: .added) == 1 ? true : false
        self.isSubscribed = try? values.decode(Int.self, forKey: .isSubscribed) == 1 ? true : false
        self.type = try values.decode(String.self, forKey: .type)
        self.likes = try? values.decode(VKLikes.self, forKey: .likes)
        self.reposts = try? values.decode(VKReposts.self, forKey: .reposts)
    }
    
}

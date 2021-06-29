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
    let description: String
    let duration: Double
    let image: [VKImage]
    let firstFrame: [VKImage]
    let date: Double
    let addingDate: Double
    let views: Int
    let localViews: Int
    let comments: Int
    let player: String
    let platform: String
    let canAdd: Bool
    let isPrivate: Bool
    let accessKey: String
    let processing: Bool?
    let isFavorite: Bool
    let canComment: Bool
    let canEdit: Bool
    let canLike: Bool
    let canRepost: Bool
    let canSubscribe: Bool
    let canAddToFaves: Bool
    let canAttachLink: Bool
    let width: Int
    let height: Int
    let userId: Int
    let converting: Bool
    let added: Bool
    let isSubscribed: Bool
    //let repeat: Bool?
    let type: String
    let likes: VKLikes
    let reposts: VKReposts
    
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
}

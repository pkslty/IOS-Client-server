//
//  VKNewsFeed.swift
//  VKApp
//
//  Created by Denis Kuzmin on 24.06.2021.
//

import Foundation

struct VKNew: Decodable {
    let type: String?
    var sourceId: Int?
    let date: Double
    let postId: Int?
    let postType: String?
    let copyOwnerId: Int?
    let ownerId: Int?
    let copyPostId: Int?
    let copyHistory: [VKNew]?
    let copyPostDate: Double?
    let text: String?
    let markedAsAds: Bool?
    let canEdit: Bool?
    let canDelete: Bool?
    let comments: VKComments?
    let likes: VKLikes?
    let reposts: VKReposts?
    let attachments: [VKAttachment]?
    //let views: Int
    let geo: VKGeo?
    let photos: VKItems<VKPhoto>?
    //let photoTags: VKPhotoTags
    let notes: VKItems<VKNote>?
    let friends: VKItems<VKFriend>?
    
    var isImagesFolded: Bool = true
    var isTextFolded: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case type
        case sourceId = "source_id"
        case date
        case postId = "post_id"
        case postType = "post_type"
        case copyOwnerId = "copy_owner_id"
        case ownerId = "owner_id"
        case copyPostId = "copy_post_id"
        case copyHistory = "copy_history"
        case copyPostDate = "copy_post_date"
        case text
        case markedAsAds = "marked_as_ads"
        case canEdit = "can_edit"
        case canDelete = "can_delete"
        case comments
        case likes
        case reposts
        case attachments
        //case views
        case geo
        case photos
        case notes
        case friends
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try? values.decode(String.self, forKey: .type)
        self.sourceId = try? values.decode(Int.self, forKey: .sourceId)
        self.date = try values.decode(Double.self, forKey: .date)
        self.postId = try? values.decode(Int.self, forKey: .postId)
        self.postType = try? values.decode(String.self, forKey: .postType)
        self.copyOwnerId = try? values.decode(Int.self, forKey: .copyOwnerId)
        self.ownerId = try? values.decode(Int.self, forKey: .ownerId)
        self.copyPostId = try? values.decode(Int.self, forKey: .copyPostId)
        /*do {
        self.copyHistory = try values.decode([VKNew].self, forKey: .copyHistory)
        } catch let error {
            print(error)
        }*/
        self.copyHistory = try? values.decode([VKNew].self, forKey: .copyHistory)
        self.copyPostDate = try? values.decode(Double.self, forKey: .copyPostDate)
        self.text = try? values.decode(String.self, forKey: .text)
        self.markedAsAds = try? values.decode(Int.self, forKey: .markedAsAds) == 1 ? true : false
        self.canEdit = try? values.decode(Int.self, forKey: .canEdit) == 1 ? true : false
        self.canDelete = try? values.decode(Int.self, forKey: .canDelete) == 1 ? true : false
        self.comments = try? values.decode(VKComments.self, forKey: .comments)
        self.likes = try? values.decode(VKLikes.self, forKey: .likes)
        self.reposts = try? values.decode(VKReposts.self, forKey: .reposts)
        self.attachments = try? values.decode([VKAttachment].self, forKey: .attachments)
        self.geo = try? values.decode(VKGeo.self, forKey: .geo)
        self.photos = try? values.decode(VKItems<VKPhoto>.self, forKey: .photos)
        self.notes = try? values.decode(VKItems<VKNote>.self, forKey: .notes)
        self.friends = try? values.decode(VKItems<VKFriend>.self, forKey: .friends)
    }
}


/*
 {
 "items": [{
 "source_id": -186154687,
 "date": 1624735291,
 "can_doubt_category": false,
 "can_set_category": false,
 "post_type": "post",
 "text": "Ни одно богатое приключениями путешествие не останется забытым

 #виаферрата #виаферратасгидом #виаферратакрым #морчекаэдвенчер #горные_приключения_в_крыму #Morcheka_Adventure #виаферрата_Севастополь #виаферратаильяская #лето_в_крыму #треккингпоКрыму #активные_туры_Крым #скалолазание_в_Крыму #альпинизм_в_Крыму #спуски_со_скал #посещение_пещер",
 "marked_as_ads": 0,
 "attachments": [...],
 "post_source": {
 "type": "vk"
 },
 "comments": {
 "count": 0,
 "can_post": 1,
 "groups_can_post": true
 },
 "likes": {
 "count": 2,
 "user_likes": 0,
 "can_like": 1,
 "can_publish": 1
 },
 "reposts": {
 "count": 0,
 "user_reposted": 0
 },
 "views": {
 "count": 41
 },
 "is_favorite": false,
 "donut": {
 "is_donut": false
 },
 "short_text_rate": 0.8,
 "post_id": 299,
 "type": "post"
 }, {

 */

//
//  VKPhoto.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.05.2021.
//

import UIKit

struct VKPhoto: Decodable {
    let prefferedPhotoSizes = ["y", "x", "z", "w", "m", "r", "q", "p", "o", "s"]
    var proportions: CGFloat
    let albumId: Int
    let date: Double
    let id: Int
    let ownerId: Int
    let hasTags: Bool
    let accessKey: String?
    let postId: Int?
    let sizes: [VKPhotoSize]
    let text: String
    let userId: Int?
    let likes: VKLikes?
    let reposts: VKReposts?
    let comments: VKComments?
    let canComment: Bool?
    let canRepost: Bool?
    let imageUrlString: String?
    

    
    
    enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case date
        case id
        case ownerId = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case postId = "post_id"
        case sizes
        case text
        case userId = "user_id"
        case likes
        case reposts
        case comments
        case canComment = "can_comment"
        case canRepost = "can_repost"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try values.decode(Int.self, forKey: .albumId)
        self.date = try values.decode(Double.self, forKey: .date)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)
        self.hasTags = try values.decode(Bool.self, forKey: .hasTags)
        self.accessKey = try? values.decode(String.self, forKey: .accessKey)
        self.postId = try? values.decode(Int.self, forKey: .postId)
        self.sizes = try values.decode([VKPhotoSize].self, forKey: .sizes)
        //self.imageUrlString = sizes.first(where: { photoSize in
        //    photoSize.width > 200
        //})?.urlString
        self.text = try values.decode(String.self, forKey: .text)
        self.userId = try? values.decode(Int.self, forKey: .userId)
        self.likes = try? values.decode(VKLikes.self, forKey: .likes)
        self.reposts = try? values.decode(VKReposts.self, forKey: .reposts)
        self.comments = try? values.decode(VKComments.self, forKey: .comments)
        self.canComment = try? values.decode(Int.self, forKey: .canComment) == 1 ? true : false
        self.canRepost = try? values.decode(Int.self, forKey: .canRepost) == 1 ? true : false
        
        var num: Int = 0
        var canExit = false
        for psize in prefferedPhotoSizes {
            for (i, size) in sizes.enumerated() {
                if size.type == psize {
                    num = i
                    print("psize=\(psize) vs size = \(size)")
                    canExit = true
                }
            }
            if canExit {
                break
            }
        }

        self.imageUrlString = sizes[num].urlString
        self.proportions = CGFloat(sizes[num].height / sizes[num].width)
    }
    
}

struct VKPhotoSize: Decodable {
    let height: Int
    let urlString: String
    let type: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case urlString = "url"
        case type
        case width
    }
}

/*
 "response": {
         "count": 56,
         "items": [
             {
                 "album_id": -7,
                 "date": 1620480667,
                 "id": 457239074,
                 "owner_id": 151236995,
                 "has_tags": false,
                 "sizes": [
                     {
                         "height": 97,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=130x97&quality=96&sign=8f5c6c30c097bc90ce45647b27a5ccc2&c_uniq_tag=xt2l6qjC-iNcu9gBVnl9gDUo-J0D2N5EDG4HT6gvgYM&type=album",
                         "type": "m",
                         "width": 130
                     },
                     {
                         "height": 98,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=130x97&quality=96&sign=8f5c6c30c097bc90ce45647b27a5ccc2&c_uniq_tag=xt2l6qjC-iNcu9gBVnl9gDUo-J0D2N5EDG4HT6gvgYM&type=album",
                         "type": "o",
                         "width": 130
                     },
                     {
                         "height": 150,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=200x150&quality=96&sign=61f8eac8bfce164dc96b7fe6e0eb8e53&c_uniq_tag=HBHLOLl-Jf2ro6Grm9pcq0TsAZMvbQRehdQXiUT3WKc&type=album",
                         "type": "p",
                         "width": 200
                     },
                     {
                         "height": 240,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=320x240&quality=96&sign=0477d68e6cac25a6a20974decf2b5a50&c_uniq_tag=QqNzTq8sdZ49dH9WeaA__zWi4YhB-WUdCG1j-f8t0J0&type=album",
                         "type": "q",
                         "width": 320
                     },
                     {
                         "height": 383,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=510x382&quality=96&sign=6def45793c9ef8731a9bcc5a021e300a&c_uniq_tag=GXeWss-uDwuIM2qzTxHttqlQz8WPQdCn97w5dQ7-aR4&type=album",
                         "type": "r",
                         "width": 510
                     },
                     {
                         "height": 56,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=75x56&quality=96&sign=cb7f306ece7caf098eafeb1062f19e00&c_uniq_tag=vvKrTO-R3lqFxAjBfgtu8rF4YqbC0-KiHSqR6IC5T-M&type=album",
                         "type": "s",
                         "width": 75
                     },
                     {
                         "height": 453,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=604x453&quality=96&sign=4cd7836c6ab4f3b1fbbccebac718628a&c_uniq_tag=jUvZ27EUt2S0vDfjPfJDgGHyCXlibz7-3N2fexJKvlA&type=album",
                         "type": "x",
                         "width": 604
                     },
                     {
                         "height": 605,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=807x605&quality=96&sign=d3464cf53b1e5b2e239d41b6246b7192&c_uniq_tag=jg6w43d9rp4bVMbjBsWe6JVWD_7HJ4_FX_uyBmFZ4Hw&type=album",
                         "type": "y",
                         "width": 807
                     },
                     {
                         "height": 960,
                         "url": "https://sun9-34.userapi.com/impg/2BXd2x9Su6mvK66QLLYHofOy2aLJCr_oDRkkhw/xBDrlN3r0zE.jpg?size=1280x960&quality=96&sign=89d9f07ef7e66a14c81dc3ea5a68ce86&c_uniq_tag=WGUQoQazbkR2DcWWDAatNUTX57-akTYNM8S5T96dHtw&type=album",
                         "type": "z",
                         "width": 1280
                     }
                 ],
                 "text": "",
                 "likes": {
                     "user_likes": 0,
                     "count": 4
                 },
                 "reposts": {
                     "count": 0
                 }
             }
 */

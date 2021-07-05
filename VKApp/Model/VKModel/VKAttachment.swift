//
//  VKAttachment.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKAttachment: Decodable {
    let type: String
    let photo: VKPhoto?
    let video: VKVideo?
    let link: VKLink?
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo
        case video
        case link
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(String.self, forKey: .type)
        self.photo = try? values.decode(VKPhoto.self, forKey: .photo)
        self.video = try? values.decode(VKVideo.self, forKey: .video)
        self.link = try? values.decode(VKLink.self, forKey: .link)
        
    }
    
}

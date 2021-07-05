//
//  VKLink.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKLink: Decodable {
    let url: String
    let title: String
    let caption: String?
    let description: String
    let photo: VKPhoto?
    //let product: VKProduct?
    //let button: VKButton?
    let previewPage: String?
    let previewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case title
        case caption
        case description
        case photo
        //case product
        //case button
        case previewPage = "preview_page"
        case previewUrl = "preview_url"
    }
}

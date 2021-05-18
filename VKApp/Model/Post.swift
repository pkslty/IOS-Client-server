//
//  Post.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

struct Post {
    var author: Person
    var date: DateComponents
    var text: String?
    var images = [UIImage]()
    var likes: UInt = 0
    var views: Int = 0
    var isImagesFolded: Bool = true
    var isTextFolded: Bool = true
}

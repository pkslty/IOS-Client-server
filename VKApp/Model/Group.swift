//
//  Group.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

struct Group {
    var name: String
    var avatar: UIImage?
    var description: String
}

extension Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return
            lhs.name == rhs.name
    }
}

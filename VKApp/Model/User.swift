//
//  User.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

struct User {
    var username: String
    var firstname: String
    var middlename: String = ""
    var lastname: String = ""
    var fullname: String {"\(firstname) \(middlename) \(lastname)"}
    var login: String
    var password: String
    var friends = [VKRealmUser]()
    var avatar: UIImage?
}

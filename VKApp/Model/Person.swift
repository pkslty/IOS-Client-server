//
//  Person.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

struct Person {
    var firstname: String
    var middlename: String = ""
    var lastname: String
    var fullname: String {"\(firstname) \(middlename) \(lastname)"}
    var avatar: UIImage?
    var photos = [(image: UIImage, likes: Int, likers: Set<String>)]()
    var posts = [Post]()
}

extension Person: Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.lastname < rhs.lastname
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.fullname == rhs.fullname
    }
    
    
}

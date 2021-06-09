//
//  Person.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

struct Person {
    var firstName: String
    var middleName: String = ""
    var lastName: String
    var fullName: String {"\(firstName) \(middleName) \(lastName)"}
    var avatar: UIImage?
    var photos = [(image: UIImage, likes: Int, likers: Set<String>)]()
    var posts = [Post]()
}

extension Person: Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.fullName == rhs.fullName
    }
    
    
}

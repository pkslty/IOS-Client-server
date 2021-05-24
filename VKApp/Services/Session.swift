//
//  Session.swift
//  VKApp
//
//  Created by Denis Kuzmin on 17.05.2021.
//

import UIKit

class Session {
    static let Instance = Session()
    
    var token = String()
    var userId = Int.zero
    
    private init() {}
}

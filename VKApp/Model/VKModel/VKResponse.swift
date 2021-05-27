//
//  VKResponse.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.05.2021.
//

import Foundation

struct VKResponse<T: Decodable>: Decodable {
    let response: T
}

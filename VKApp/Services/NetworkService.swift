//
//  NetworkService.swift
//  VKApp
//
//  Created by Denis Kuzmin on 24.05.2021.
//

import UIKit

class NetworkService {
    static private let session = URLSession.shared
    static private var url: URLComponents = {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        return urlConstructor
        }()
    static private let api_version = "5.132"
    
    
    static func getFriends(of userId: Int = Session.Instance.userId, completionBlock: @escaping ([VKRealmUser]) -> Void) {
        let parameters = [
            "order" : "hints",
            "fields" : "nickname,photo_200_orig",
            "user_id" : String(userId),
        ]
        request(method: "friends.get", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKRealmUser>>.self, from: data)
            else {
                print("JSON Decode fail")
                return
            }
            completionBlock(vkResponse.response.items)
        }
    }
    
    static func getUserById(id: Int, completionBlock: @escaping ([VKUser]) -> Void) {
        let parameters = [
            "user_ids" : String(id),
            "fields" : "photo_200_orig",
        ]
        request(method: "users.get", parameters: parameters) { data in
            do {
                let vkResponse = try JSONDecoder().decode(VKResponse<[VKUser]>.self, from: data)
                completionBlock(vkResponse.response)
            }
            catch let error {
                print("JSON error: \(error)")
                return
            }
        }
    }
    
    static func getGroupById(id: Int, completionBlock: @escaping ([VKGroup]) -> Void) {
        let parameters = [
            "group_ids" : String(id),
            "fields" : "photo_200",
        ]
        request(method: "groups.getById", parameters: parameters) { data in
            do {
                let vkResponse = try JSONDecoder().decode(VKResponse<[VKGroup]>.self, from: data)
                completionBlock(vkResponse.response)
            }
            catch let error {
                print("JSON error: \(error)")
                return
            }
        }
    }
    
    static func performVkMethod(method: String, with parameters: [String: String], token: String = Session.Instance.token, completionBlock: @escaping (Data) -> Void) {
        request(method: method, parameters: parameters, token: token) { data in
            completionBlock(data)
        }
    }
    
    static func getGroups(of userId: Int = Session.Instance.userId, callBack: @escaping ([VKRealmGroup]) -> Void) {
        let parameters = [
            "extended" : "1",
            "user_id" : String(userId),
        ]
        
        request(method: "groups.get", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKRealmGroup>>.self, from: data)
            else {
                print("JSON Decode fail")
                return
            }
            callBack(vkResponse.response.items)
        }
    }
    
    static func searchGroups(by query: String, resultsCount: Int, completionBlock: @escaping ([VKRealmGroup]) -> Void) {
        let parameters = [
            "q" : query,
            "count" : String(resultsCount),
        ]
        request(method: "groups.search", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKRealmGroup>>.self, from: data)
            else {
                print("JSON Decode fail")
                return
            }
            completionBlock(vkResponse.response.items)
        }

    }
    
    static func getPhotos(of userId: Int, completionBlock: @escaping ([VKRealmPhoto]) -> Void) {
        let parameters = [
            "owner_id" : String(userId),
            "extended" : "1",
        ]
        request(method: "photos.getAll", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKRealmPhoto>>.self, from: data)
            else {
                print("JSON Decode fail")
                return
            }
            DispatchQueue.main.async {
                completionBlock(vkResponse.response.items)
            }
            //callBack(vkResponse.response.items)
        }

    }
    
    static private func request(method: String, parameters: [String: String], token: String = Session.Instance.token, completionBlock: @escaping (Data) -> Void) {
        url.path = "/method/" + method
        url.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: api_version)]
        for (parameter, value) in parameters {
            url.queryItems?.append(
                URLQueryItem(name: parameter, value: value))
        }
        
        guard let url = url.url else { return }
        print(url)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Request error: \(String(describing: error))")
            return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                completionBlock(data)
            }
            //let queue = DispatchQueue.global()
            /*queue.async {
                completionBlock(data)
            }*/

        }
        task.resume()

    }
    
    static func getData(from url: String, completionBlock: @escaping (Data) -> Void) {
        guard let url = URL(string: url)
        else {
            print("NetworkService error: Invalid url")
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("NetworkService error: \(String(describing: error))")
                print("URL: \(url)")
            return
            }
            guard let data = data
            else {
                print("NetworkService error: No data")
                return
            }
            let queue = DispatchQueue.global()
            queue.async {
                completionBlock(data)
            }
            /*DispatchQueue.main.async {
                completionBlock(data)
            }*/
            //completionBlock(data)

        }
        task.resume()
    }
    
}

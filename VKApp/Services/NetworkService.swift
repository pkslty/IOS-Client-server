//
//  NetworkService.swift
//  VKApp
//
//  Created by Denis Kuzmin on 24.05.2021.
//

import Foundation

class NetworkService {
    private let session = URLSession.shared
    private var url: URLComponents = {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        return urlConstructor
        }()
    private let api_version = "5.132"
    
    func getFriends(of userId: Int = Session.Instance.userId, callBack: @escaping ([VKRealmUser]) -> Void) {
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
            callBack(vkResponse.response.items)
        }
    }
    
    func getGroups(of userId: Int = Session.Instance.userId, callBack: @escaping ([VKRealmGroup]) -> Void) {
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
    
    func searchGroups(by query: String, resultsCount: Int, callBack: @escaping ([VKRealmGroup]) -> Void) {
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
            callBack(vkResponse.response.items)
        }

    }
    
    func getPhotos(of userId: Int, callBack: @escaping ([VKRealmPhoto]) -> Void) {
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
            callBack(vkResponse.response.items)
        }

    }
    
    private func request(method: String, parameters: [String: String], completionBlock: @escaping (Data) -> Void) {
        url.path = "/method/" + method
        url.queryItems = [
            URLQueryItem(name: "access_token", value: Session.Instance.token),
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
            completionBlock(data)

        }
        task.resume()

    }
    
}

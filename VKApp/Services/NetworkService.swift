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
    
    func getFriends(callBack: @escaping ([VKUser]) -> Void) {
        let parameters = [
            "order" : "hints",
            "fields" : "nickname,photo_200_orig",
        ]
        request(method: "friends.get", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKUser>>.self, from: data)
            else {
                print("JSON Decode fail")
                return
            }
            callBack(vkResponse.response.items)
        }
    }
    
    func getGroups(of userId: Int = Session.Instance.userId, callBack: @escaping ([VKGroup]) -> Void) {
        let parameters = [
            "extended" : "1",
            "user_id" : String(userId),
        ]
        
        request(method: "groups.get", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKGroup>>.self, from: data)
            else {
                print("JSON Decode fail")
                return
            }
            callBack(vkResponse.response.items)
        }
    }
    
    func searchGroups(by query: String, count: Int) {
        let parameters = [
            "q" : query,
            "count" : String(count),
        ]
        request(method: "groups.search", parameters: parameters) { json in
            print("Search groups json: \(json)")
        }

    }
    
    func getPhotos(of userId: Int, callBack: @escaping ([VKPhoto]) -> Void) {
        let parameters = [
            "owner_id" : String(userId),
            "extended" : "1",
        ]
        request(method: "photos.getAll", parameters: parameters) { data in
            guard let vkResponse = try? JSONDecoder().decode(VKResponse<VKItems<VKPhoto>>.self, from: data)
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

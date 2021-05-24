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
    
    func getFriends() {
        let parameters = [
            "order" : "hints",
            "fields" : "nickname",
        ]
        request(method: "friends.get", parameters: parameters) { json in
            print("Friends json: \(json)")
        }
    }
    
    func getGroups() {
        let parameters = [
            "extended" : "1",
        ]
        request(method: "groups.get", parameters: parameters) { json in
            print("Groups json: \(json)")
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
    
    func getPhotos(of userId: Int) {
        let parameters = [
            "owner_id" : String(userId),
            "extended" : "1",
        ]
        request(method: "photos.getAll", parameters: parameters) { json in
            print("Photos json: \(json)")
        }

    }
    
    private func request(method: String, parameters: [String: String], completionBlock: @escaping (Any) -> Void) {
        url.path = "/method/" + method
        url.queryItems = [
            URLQueryItem(name: "access_token", value: Session.Instance.token),
            URLQueryItem(name: "v", value: "5.132")]
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
            do {
                let json = try JSONSerialization.jsonObject(
                    with: data,
                    options: .allowFragments)
                completionBlock(json)
            }
            catch {
                print("JSON serialization error: \(error)")
            }
        }
        task.resume()

    }
    
}

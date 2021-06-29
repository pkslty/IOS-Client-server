//
//  VKUser.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.05.2021.
//

import Foundation

struct VKUser: Decodable {
    let firstName: String
    let id: Int
    let lastName: String
    let avatarUrlString: String
    var fullName: String {"\(firstName) \(lastName)"}
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case avatarUrlString = "photo_200_orig"
    }
}



/*
 {
     "response": {
         "count": 1,
         "items": [
             {
                 "first_name": "Александр",
                 "id": 151236995,
                 "last_name": "Твердохлеб",
                 "can_access_closed": true,
                 "is_closed": false,
                 "nickname": "",
                 "photo_200_orig": "https://sun3-10.userapi.com/s/v1/ig2/-id9GxAG_m5rAeZe-irbNEVizznohy7p867A3jw4HgeGQmx2s2piHO6Jyq82TpDwH8fIQe92l2GXQoeeFVu3rwLM.jpg?size=200x0&quality=96&crop=71,107,1298,1946&ava=1",
                 "track_code": "1e118548zoXgg9uzvSIqtygv7kytiUiyyLqFYBStW7SxP8_tDjij7rq1trS_IyC9HvQO4CHlO6bRtpIOcA"
             }
         ]
     }
 }
 */

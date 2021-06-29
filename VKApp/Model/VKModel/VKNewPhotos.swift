//
//  VKNewPhotos.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.06.2021.
//

import Foundation

struct VKNewPhotos: Decodable {
    let count: Int
    let items: [VKPhoto]
    
}


/*
 "photos": {
 "count": 1,
 "items": [{
 "album_id": -7,
 "date": 1624735291,
 "id": 457239820,
 "owner_id": -186154687,
 "has_tags": false,
 "access_key": "cd6a58574823695dd5",
 "post_id": 299,
 "sizes": [{
 "height": 130,
 "url": "https://sun9-35.u...Jboc&type=album",
 "type": "m",
 "width": 104
 }, {...}, {...}, {...}, {...}, {...}, {...}, {...}, {...}, {...}],
 "text": "Ни одно богатое приключениями путешествие не останется забытым

 #виаферрата #виаферратасгидом #виаферратакрым #морчекаэдвенчер #горные_приключения_в_крыму #Morcheka_Adventure #виаферрата_Севастополь #виаферратаильяская #лето_в_крыму #треккингпоКрыму #активные_туры_Крым #скалолазание_в_Крыму #альпинизм_в_Крыму #спуски_со_скал #посещение_пещер",
 "user_id": 100,
 "likes": {
 "user_likes": 0,
 "count": 2
 },
 "reposts": {
 "count": 0,
 "user_reposted": 0
 },
 "comments": {
 "count": 0
 },
 "can_comment": 1,
 "can_repost": 1
 }]
 }
 */

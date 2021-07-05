//
//  ImageLoader.swift
//  VKApp
//
//  Created by Denis Kuzmin on 08.06.2021.
//

import UIKit

class ImageLoader {

    static private var imageCache = NSCache<NSString, UIImage>()
    
    static func getImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let image = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        else {
            NetworkService.getData(from: urlString) { data in
                let image = UIImage(data: data)
                if image != nil {
                    //self.imageCache[urlString] = image
                    self.imageCache.setObject(image!, forKey: urlString as NSString)
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
        }
    }
    
}

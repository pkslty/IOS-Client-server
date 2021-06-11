//
//  ImageLoader.swift
//  VKApp
//
//  Created by Denis Kuzmin on 08.06.2021.
//

import UIKit

class ImageLoader {
    /*static private var imageCache = [String: UIImage]() {
        didSet {
            print("ImageLoader cache: \(imageCache.count) objects")
        }
    }*/
    static private var imageCache = NSCache<NSString, UIImage>()
    
    static func getImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        /*if let image = imageCache[urlString] {
            DispatchQueue.main.async {
                completion(image)
            }
        }*/
        if let image = imageCache.object(forKey: urlString as NSString) {
            print("From cache")
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        else {
            let ns = NetworkService()
            ns.getData(from: urlString) { data in
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

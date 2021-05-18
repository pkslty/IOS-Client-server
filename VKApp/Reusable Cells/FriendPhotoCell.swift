//
//  FriendPhoto.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

class FriendPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var photo: UIImageView!
    var photoframe = CGRect.zero
    
    
    func config(image: UIImage, likes: Int, tag: Int, state: Bool) {
        likeButton.likes = likes
        photo.image = image
        likeButton.tag = tag
        likeButton.isLiked = state
        photoframe = photo.frame
        photo.alpha = 0
        photo.frame = CGRect(x: photo.center.x, y: photo.center.y, width: 0, height: 0)
        

    }

    func animateDisappear() {
        
        UIView.animate(withDuration: 0.5) { [self] in
        photo.alpha = 0
        photo.frame = CGRect(x: photo.center.x, y: photo.center.y, width: 0, height: 0)
        }
    }
    
    func animateAppear() {
        
        UIView.animate(withDuration: 0.5, delay: 0) { [self] in
            photo.alpha = 1
            photo.frame = photoframe
        }
        
    }

}

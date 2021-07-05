//
//  ActionsCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 18.04.2021.
//

import UIKit

class NewsActionsCell: UICollectionViewCell {

    @IBOutlet weak var likeButton: ActionButton!
    @IBOutlet weak var repostButton: ActionButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(likes: VKLikes?, reposts: VKReposts?, tag: Int) {
        
        likeButton.tag = tag
        
        if let likes = likes {
            likeButton.count = likes.count
            likeButton.pressed = likes.userLikes
        }
        else {
            likeButton.count = 0
            likeButton.pressed = false
        }
        if let reposts = reposts {
            repostButton.count = reposts.count
            repostButton.pressed = reposts.userReposted
        }
        else {
            repostButton.count = 0
            repostButton.pressed = false
        }
        
    }
}

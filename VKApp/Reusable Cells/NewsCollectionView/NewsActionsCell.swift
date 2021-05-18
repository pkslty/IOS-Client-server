//
//  ActionsCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 18.04.2021.
//

import UIKit

class NewsActionsCell: UICollectionViewCell {

    @IBOutlet weak var likeButton: LikeButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(likes: Int, tag: Int, state: Bool) {
        likeButton.likes = likes
        likeButton.isLiked = state
        likeButton.tag = tag
    }
}

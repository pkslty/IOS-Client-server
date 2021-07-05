//
//  NewsAuthorCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 18.04.2021.
//

import UIKit

class NewsAuthorCell: UICollectionViewCell {

    @IBOutlet weak var authorPhoto: RoundShadowView!
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var postDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(imageUrlString: String, name: String, date: Double, isRepost: Bool = false) {
        ImageLoader.getImage(from: imageUrlString) { [weak self] image in
            self?.authorPhoto.image = image
        }
        
        authorName.text = isRepost ? "\u{21a9} \(name)" : name
        postDate.text = NSDate(timeIntervalSince1970: date).description
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorName.text = String()
        postDate.text = String()
        authorPhoto.image = nil
    }
    
}

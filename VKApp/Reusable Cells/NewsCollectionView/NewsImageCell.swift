//
//  NewsImageCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 18.04.2021.
//

import UIKit


class NewsImageCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var plus: UILabel!
    
    func configure(imageUrlString: String, plus: Int?) {
        ImageLoader.getImage(from: imageUrlString) { [weak self] image in
            self?.image.image = image
        }
        /*self.plus.isHidden = true
        guard let plus = plus, plus > 0 else { return}
        self.plus.isHidden = false
        self.plus.text = "+\(plus)"*/
    }
    
    override func prepareForReuse() {
        image.image = nil
        plus.text = nil
    }
}

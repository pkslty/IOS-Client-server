//
//  NewsTextCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 18.04.2021.
//

import UIKit

class NewsTextCell: UICollectionViewCell {

    @IBOutlet weak var text: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(text: String) {
        self.text.text = text
    }
    
}

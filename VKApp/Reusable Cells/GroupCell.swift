//
//  UserGroupCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupCellText: UILabel!
    @IBOutlet weak var groupDescriptionText: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
   
    func config(name: String, avatarUrlString: String, description: String) {
        groupCellText.text = name
        groupDescriptionText.text = description
        ImageLoader.getImage(from: avatarUrlString) { [weak self] image in
            self?.groupImage.image = image
        }
    }

}

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
   
    func config(name: String, avatar: UIImage, description: String) {
        groupCellText.text = name
        groupDescriptionText.text = description
        groupImage.image = avatar
    }

}

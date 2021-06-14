//
//  friendsTableCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {

    //@IBOutlet weak var avatarSize: NSLayoutConstraint!
    
    @IBOutlet weak var friendName: UILabel!
    
    
    @IBOutlet weak var avatarImage: RoundShadowView!
    
    
    func config(name: String?, avatarUrlString: String) {

        friendName.text = name
        avatarImage.shadowColor = UIColor.blue.cgColor
        ImageLoader.getImage(from: avatarUrlString) { [weak self] image in
            self?.avatarImage.image = image
        }
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(avatarTap))
        gestureRecognizer.minimumPressDuration = 0.2
        avatarImage.addGestureRecognizer(gestureRecognizer)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImage.image = UIImage(systemName: "person")
        friendName.text = String()
    }
    
    @objc func avatarTap(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            avatarImage.springAnimateScale(duration: 0.7, scale: 0.96)
        }
       
        
        //avatarImage.frame = rect
        //avatarSize.constant = 66
        
    }
}

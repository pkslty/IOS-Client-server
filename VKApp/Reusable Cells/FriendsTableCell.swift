//
//  friendsTableCell.swift
//  VKApp
//
//  Created by Denis Kuzmin on 05.04.2021.
//

import UIKit

class FriendsTableCell: UITableViewCell {

    @IBOutlet weak var avatarSize: NSLayoutConstraint!
    
    @IBOutlet weak var friendName: UILabel!
    
    
    @IBOutlet weak var avatarImage: RoundShadowView!
    
    
    func config(name: String?, avatar: UIImage?) {

        friendName.text = name
        avatarImage.shadowColor = UIColor.blue.cgColor
        avatarImage.image = avatar
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(avatarTap))
        gestureRecognizer.minimumPressDuration = 0.2
        avatarImage.addGestureRecognizer(gestureRecognizer)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImage.image = UIImage(systemName: "person")
    }
    
    @objc func avatarTap(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            avatarImage.springAnimateScale(duration: 0.7, scale: 0.96)
        }
       
        
        //avatarImage.frame = rect
        //avatarSize.constant = 66
        
    }
}

//
//  FriendsTableCellHeader.swift
//  VKApp
//
//  Created by Denis Kuzmin on 16.04.2021.
//

import UIKit

class FriendsTableCellHeader: UITableViewHeaderFooterView {

    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(title)
    }
    
    func configure(text: String) {
        
        title.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.widthAnchor.constraint(equalToConstant: 50),
            title.heightAnchor.constraint(equalToConstant: 50),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.isOpaque = true
        
        title.text = text
    }
    
}

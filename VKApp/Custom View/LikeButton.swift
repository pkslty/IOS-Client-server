//
//  LikeButton.swift
//  VKApp
//
//  Created by Denis Kuzmin on 10.04.2021.
//

import UIKit

protocol LikeButtonProtocol {
    func updateLike(likes: Int, tag: Int, like: Bool)
}

@IBDesignable class LikeButton: UIControl {

    private let button = UIButton(type: .system)
    private let label = UILabel(frame: CGRect.zero)
    private var stackView: UIStackView!
    @IBInspectable var labelFontSize: CGFloat = UIFont.systemFontSize {
        didSet {
            setNeedsLayout()
        }
    }
    
    var likes: Int = 0
    var isLiked: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var delegate: LikeButtonProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        setState()
    }
    
    private func setUpView() {
        
        backgroundColor = .clear
        button.tintColor = .systemRed
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.addTarget(self, action: #selector(self.setLike(_:)), for: .touchUpInside)
        
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        
        setState()
        
        stackView = UIStackView(arrangedSubviews: [label, button])
        addSubview(stackView)
        //stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
    }
    
    @objc private func setLike(_ sender: UIButton) {
        if isLiked {
            likes -= 1
            isLiked.toggle()
            setState()
        } else {
            likes += 1
            isLiked.toggle()
            setState()
        }
        delegate?.updateLike(likes: likes, tag: tag, like: isLiked)
        sendActions(for: .valueChanged)
    }
    
    private func setState() {
        
        //Анимация: устанавливаться лайк будет быстро, а сниматься медленно и нехотя
        isLiked ?
            {
                button.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                label.text = String(likes)
                
            }() :
            {
                UIView.transition(with: button, duration: 0.6, options: .transitionCrossDissolve) { [self] in
                button.setImage(UIImage(systemName: "suit.heart"), for: .normal) }
                UIView.transition(with: label, duration: 0.5, options: .transitionCrossDissolve) { [self] in
                    label.text = String(likes) }
                
            }()

    }
}

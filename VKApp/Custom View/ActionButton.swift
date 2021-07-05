//
//  LikeButton.swift
//  VKApp
//
//  Created by Denis Kuzmin on 10.04.2021.
//

import UIKit

protocol ActionButtonProtocol {
    func updateState(likes: Int, tag: Int, like: Bool)
}

@IBDesignable class ActionButton: UIControl {

    enum ButtonType: Int {
        case like = 1
        case repost = 2
    }
    
    private let button = UIButton(type: .system)
    private let label = UILabel(frame: CGRect.zero)
    private var stackView: UIStackView!
    @IBInspectable var labelFontSize: CGFloat = UIFont.systemFontSize {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var type: Int = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var color: UIColor = .systemRed {
        didSet {
            setUpView()
        }
    }
    
    var count: Int = 0
    var pressed: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var delegate: ActionButtonProtocol?
    
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
        changeState()
    }
    
    private func setUpView() {
        
        backgroundColor = .clear
        button.tintColor = color
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.white, for: .selected)
        
        button.addTarget(self, action: #selector(self.setState(_:)), for: .touchUpInside)
        
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: labelFontSize)
        
        changeState()
        
        stackView = UIStackView(arrangedSubviews: [label, button])
        addSubview(stackView)
        //stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
    }
    
    @objc private func setState(_ sender: UIButton) {
        if pressed {
            count -= 1
            pressed.toggle()
            changeState()
        } else {
            count += 1
            pressed.toggle()
            changeState()
        }
        delegate?.updateState(likes: count, tag: tag, like: pressed)
        sendActions(for: .valueChanged)
    }
    
    private func changeState() {
        
        //Анимация: устанавливаться лайк будет быстро, а сниматься медленно и нехотя
        pressed ?
            {
            switch type {
            case ButtonType.like.rawValue:
                button.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            case ButtonType.repost.rawValue:
                button.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
            default:
                break
            }
                label.text = String(count)
                
            }() :
            {
                UIView.transition(with: self.button, duration: 0.6, options: .transitionCrossDissolve) { [self] in
                    switch type {
                    case ButtonType.like.rawValue:
                        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    case ButtonType.repost.rawValue:
                        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
                    default:
                        break
                    }
                }
                UIView.transition(with: label, duration: 0.5, options: .transitionCrossDissolve) { [self] in
                    label.text = String(count) }
                
            }()

    }
}

//
//  CategoriesPicker.swift
//  VKApp
//
//  Created by Denis Kuzmin on 11.04.2021.
//

import UIKit

@IBDesignable class CategoriesPicker: UIControl {

    // MARK: - Nested types
    
    enum PickerStyle {
        case all        //Выводим все категории
        case dotted  //С разделителями, если слишком много категорий - пропускаем
        case adaptive  //Когда категорий слишком мало выводим с разделителями, слишком много - с разделителями и пропускми
    }
    
    // MARK: - @IBIspectable properties
    
    @IBInspectable var symbolHeight: CGFloat = 30.0 //Высота символа категории
    
    // MARK: - Properties
    
    var categories = [String]() {
        didSet {
            setNeedsLayout()
        }
    }
    var pickedCategory: Int = 0
    
    var style: PickerStyle = .dotted
    
    private var buttons = [UIButton]()
    private var stackView: UIStackView?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    // MARK: - Overrided methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCategories()
        stackView?.frame = bounds
    }
    
    // MARK: - Private methods
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        pickedCategory = sender.tag
        sendActions(for: .valueChanged)
    }
    
    @objc private func controlPan(_ recognizer: UIGestureRecognizer) {
        var y = recognizer.location(in: self).y
        if y < 0 { y = 0}
        else if y > bounds.height {y = bounds.height }
        pickedCategory = Int(y / bounds.height * CGFloat(categories.count-1))
        sendActions(for: .valueChanged)
    }
    
    private func makeButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: .touchUpInside)
        button.tag = tag
        return button
    }
    
    private func setUpView() {
        backgroundColor = .clear
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(controlPan(_:)))
        addGestureRecognizer(panGestureRecognizer)
        updateCategories()
    }
    
    private func updateCategories() {
        buttons = []
        if stackView != nil {
            stackView!.removeFromSuperview()
        }
        guard categories.count > 0 else { return}
        
        let capasity = Int(bounds.height / symbolHeight)
        var isAdaptive: Bool
        if style == .adaptive {
            isAdaptive =
                (categories.count > capasity) || (categories.count * 2 < capasity) ? true : false
        } else {
            isAdaptive = style == .dotted ? true : false
        }
        
        var maxSymbols = categories.count
        if Int(bounds.height / symbolHeight) < categories.count && isAdaptive {
            maxSymbols = Int(bounds.height / symbolHeight)
        }
        let step = Int(Double(categories.count / maxSymbols).rounded())
        buttons.append(makeButton(title: categories.first!, tag: 0))
        if isAdaptive {
            buttons.append(makeButton(title: "\u{2022}", tag: Int(step / 2)))
        }
        if maxSymbols > 1 {
        for i in 1 ..< maxSymbols - 1 {
            let tag = i * step
            let title = categories[tag]
            buttons.append(makeButton(title: title, tag: tag))
            if isAdaptive {
                buttons.append(makeButton(title: "\u{2022}", tag: tag + Int(step / 2)))
            }
        }
        }
        buttons.append(makeButton(title: categories.last!, tag: categories.count - 1))
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView!.backgroundColor = .clear
        addSubview(stackView!)
        stackView!.axis = .vertical
        stackView!.alignment = .center
        stackView!.distribution = .fillEqually
    }
    
    

}

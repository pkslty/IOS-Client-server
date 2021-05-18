//
//  LoadingIndicator.swift
//  VKApp
//
//  Created by Denis Kuzmin on 22.04.2021.
//

import UIKit

@IBDesignable class LoadingIndicator: UIView {

    @IBInspectable var color: UIColor = .systemBlue
    @IBInspectable var dotSize: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    

        
    
    private func setupView() {
        
        for i in 0...2 {
            let origin = CGPoint(x: bounds.width*(1/6 + CGFloat(i)/3), y: bounds.height/2)
            let size = CGSize(width: dotSize, height: dotSize)
            let subview = UIView(frame: CGRect(origin: origin, size: size))
            subview.backgroundColor = color
            subview.layer.cornerRadius = dotSize / 2
            subview.layer.masksToBounds = true
            addSubview(subview)
        }
        subviews[1].alpha = 0.5
        subviews[2].alpha = 0
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.repeat]) {
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 0.5) {
            self.subviews.first?.alpha = 0
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5,
                           relativeDuration: 0.5) {
            self.subviews.first?.alpha = 1
        }
        UIView.addKeyframe(withRelativeStartTime: 0.0,
                           relativeDuration: 0.25) {
            self.subviews[1].alpha = 1
        }
        UIView.addKeyframe(withRelativeStartTime: 0.25,
                           relativeDuration: 0.5) {
            self.subviews[1].alpha = 0
        }
        UIView.addKeyframe(withRelativeStartTime: 0.75,
                           relativeDuration: 0.25) {
            self.subviews[1].alpha = 0.5
        }
        UIView.addKeyframe(withRelativeStartTime: 0.0,
                           relativeDuration: 0.5) {
            self.subviews[2].alpha = 1
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5,
                           relativeDuration: 0.5) {
            self.subviews[2].alpha = 0
        }
            
        }
    }
}

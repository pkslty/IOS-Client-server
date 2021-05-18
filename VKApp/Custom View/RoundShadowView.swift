//
//  RoundShadowView.swift
//  VKApp
//
//  Created by Denis Kuzmin on 09.04.2021.
//

import UIKit

@IBDesignable class RoundShadowView: UIView {

    //MARK - @IBInspectable properties
    
    @IBInspectable var autoSizeForRadius: Bool = true {
        didSet {
            if autoSizeForRadius {
                radius = frame.height / 2
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var autoSizeForShadow: Bool = true {
        didSet {
            if autoSizeForShadow {
                shadowRadius = radius / 10
                shadowOffset = CGSize(width: radius / 10, height: radius / 10)
            }
        }
    }
    
    @IBInspectable var radius: CGFloat = 20 {
        didSet {
            if autoSizeForShadow {
                shadowRadius = radius / 10
                shadowOffset = CGSize(width: radius / 10, height: radius / 10)
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2, height: 2)
    
    var image: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowOpacity: CGFloat = 0.9
    
    @IBInspectable private var shadowRadius: CGFloat = 2
    
    //MARK - Properties
    
    private let imageView = UIImageView()
    
    var shadowColor = UIColor.black.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let shadowLayer = CALayer()
    
    private let imageLayer = CALayer()
    
    // MARK - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    //MARK - Overrided methods
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        shadowLayer.frame = frame
        imageLayer.frame = frame
        
        if autoSizeForShadow {
            shadowRadius = radius / 10
        }
        if autoSizeForRadius {
            radius = imageLayer.frame.height / 2
        }

        imageLayer.contents = image?.cgImage
        imageLayer.cornerRadius = radius
        
        shadowLayer.cornerRadius = radius
        shadowLayer.shadowColor = shadowColor
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOffset = shadowOffset

        
        

    }
    
    func springAnimateScale(duration: TimeInterval, scale: CGFloat) {
        
        CATransaction.begin()
            let animation1 = CASpringAnimation(keyPath: "transform.scale")
            animation1.fromValue = 1
            animation1.toValue = scale
            animation1.mass = 5
            animation1.stiffness = 100
            animation1.initialVelocity = 15
            animation1.duration = duration / 2
            layer.add(animation1, forKey: nil)
            let animation2 = CASpringAnimation(keyPath: "transform.scale")
            animation2.fromValue = scale
            animation2.toValue = 1
            animation2.mass = 5
            animation2.stiffness = 100
            animation2.initialVelocity = 15
            animation2.duration = duration / 2
            animation2.beginTime = CACurrentMediaTime() + 0.4 * duration 
            layer.add(animation2, forKey: nil)
        CATransaction.commit()

    }
    
    //MARK - Private methods    
    
    private func setUpView(){
        backgroundColor = .clear
        
        imageLayer.frame = frame
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.cornerRadius = radius
        imageLayer.masksToBounds = true
        
        shadowLayer.cornerRadius = radius
        shadowLayer.shadowOpacity = 0.9
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.frame = frame
        shadowLayer.zPosition = -1
        layer.addSublayer(shadowLayer)
        layer.addSublayer(imageLayer)
    }
    
}

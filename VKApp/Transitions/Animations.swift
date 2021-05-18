//
//  Animations.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.04.2021.
//

import UIKit

class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to),
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        containerView.addSubview(destinationView)

        let rotations = 3.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            containerView.backgroundColor = .systemBackground
            
            transitionContext.completeTransition(true)
        }
            let animation1 = CABasicAnimation(keyPath: "transform.scale")
            animation1.fromValue = 0.1
            animation1.toValue = 1
            animation1.duration = timeInterval
            animation1.repeatCount = 1
            destinationView.layer.add(animation1, forKey: nil)
            let animation2 = CABasicAnimation(keyPath: "transform.rotation")
            animation2.fromValue = 0
            
            animation2.toValue = 2 * Double.pi
            animation2.duration = timeInterval / rotations
            animation2.repeatCount = Float(rotations)
            destinationView.layer.add(animation2, forKey: nil)
        CATransaction.commit()      
    }
}

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.5
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to),
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        destinationView.alpha = 0
        destinationView.backgroundColor = .black
        containerView.backgroundColor = .black
        containerView.insertSubview(destinationView, belowSubview: sourceView)
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            destinationView.alpha = 1
            destinationView.backgroundColor = .systemBackground
            containerView.backgroundColor = .systemBackground
            transitionContext.completeTransition(true)
        }
        let animation1 = CABasicAnimation(keyPath: "transform.scale.y")
        animation1.fromValue = 1
        animation1.toValue = 0.005
        animation1.duration = timeInterval * 0.4
        animation1.repeatCount = 1
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        animation1.beginTime = CACurrentMediaTime()
        sourceView.layer.add(animation1, forKey: nil)
        let animation2 = CABasicAnimation(keyPath: "transform.scale.x")
        animation2.fromValue = 1
        animation2.toValue = 0.01
        animation2.duration = timeInterval * 0.5
        animation2.repeatCount = 1
        animation2.beginTime = CACurrentMediaTime() + timeInterval * 0.5
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = .forwards
        sourceView.layer.add(animation2, forKey: nil)
        CATransaction.commit()
    }
}

class PercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isStarted: Bool = false
    var shouldFinish: Bool = false
}

class FriendPhotoPushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) as? FriendPhotosViewController,
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to) as? PhotoPresenterViewController,
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        containerView.addSubview(destinationView)
        var sourceFrame = CGRect.zero
        var targetFrame = CGRect.zero
        
        if let navigationController = destination.navigationController,
           let tabBarController = destination.tabBarController,
           let collectionView = source.collectionView,
           let index = collectionView.indexPathsForSelectedItems?.first,
           let rect = collectionView.layoutAttributesForItem(at: index)?.frame {
            let contentOffset = collectionView.contentOffset
            sourceFrame = rect
            sourceFrame.origin = CGPoint(x: sourceFrame.minX, y: sourceFrame.minY - contentOffset.y)
            
            let y = navigationController.navigationBar.frame.minY + navigationController.navigationBar.frame.height
            let height = tabBarController.tabBar.frame.minY - y
            targetFrame = CGRect(x: 0, y: y, width: destination.view.frame.width, height: height)
        }
        destination.mainImageView.frame = sourceFrame
        UIView.animateKeyframes(withDuration: timeInterval, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1.0,
                               animations: {sourceView.alpha = 0})
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1.0,
                               animations: {destination.mainImageView.frame = /*targetFrame*/destination.rect})
        } completion: { complete in
            transitionContext.completeTransition(complete)
        }

        
       
    }
}


class FriendPhotosInteractivePopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.0
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) as? PhotoPresenterViewController,
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to) as? FriendPhotosViewController,
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        //destination.currentImage = source.currentImage
        destinationView.alpha = 0
        containerView.backgroundColor = .systemBackground
        containerView.insertSubview(destinationView, belowSubview: sourceView)
        //print(sourceView.subviews)
        
        UIView.animate(withDuration: timeInterval) {
            destinationView.alpha = 1
        } completion: { complete in
            transitionContext.completeTransition(complete && !transitionContext.transitionWasCancelled)
        }
        
        
    }
}

class FriendPhotosPopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.5
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) as? PhotoPresenterViewController,
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to) as? FriendPhotosViewController,
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        destinationView.alpha = 0
        containerView.insertSubview(destinationView, belowSubview: sourceView)
        var targetFrame = CGRect.zero
        
        let index = IndexPath(row: source.currentImage, section: 0)

        if let collectionView = destination.collectionView,
           let rect = collectionView.layoutAttributesForItem(at: index)?.frame {
            destination.collectionView.scrollToItem(at: index,
                                                    at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
            let contentOffset = collectionView.contentOffset
            targetFrame = rect
            targetFrame.origin = CGPoint(x: targetFrame.minX, y: targetFrame.minY - contentOffset.y)
        }

        UIView.animateKeyframes(withDuration: timeInterval, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1.0,
                               animations: {destinationView.alpha = 1})
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1.0,
                               animations: {source.mainImageView.frame = targetFrame})
        } completion: { complete in
            transitionContext.completeTransition(complete)
        }

        
       
    }
}

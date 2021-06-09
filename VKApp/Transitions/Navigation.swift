//
//  Navigation.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.04.2021.
//

import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let pushAnimator = PushAnimation()
    let popAnimator = PopAnimation()
    let friendPhotoPushAnimator = FriendPhotoPushAnimation()
    let friendPhotosInteractivePopAnimator = FriendPhotosInteractivePopAnimation()
    let friendPhotosPopAnimator = FriendPhotosPopAnimation()
    var lastVisibleViewController: UIViewController?
    var recognizer = UIPanGestureRecognizer()
    let interactiveTransition = PercentDrivenInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesure))
        
        view.addGestureRecognizer(recognizer)
        //panNavrecognizer.delegate = PhotoPresenterViewController
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if let lastVisibleViewController = lastVisibleViewController as? FriendPhotosViewController,
           let friend = lastVisibleViewController.friend,
           let friendNum = lastVisibleViewController.friendNum,
           let viewController = viewController as? FriendsViewController {
            //viewController.user?.friends[friendNum].photos = friend.photos
        }
        lastVisibleViewController = visibleViewController
            
    }
    
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            if let _ = fromVC as? FriendPhotosViewController,
               let _ = toVC as? PhotoPresenterViewController {
                return friendPhotoPushAnimator
            } else {
                return pushAnimator
            }
        case .pop:
            if let _ = toVC as? FriendPhotosViewController {
                if interactiveTransition.isStarted  {
                    return friendPhotosInteractivePopAnimator
                } else {
                    return friendPhotosPopAnimator
                }
            } else {
                return popAnimator
            }
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactiveTransition.isStarted ? interactiveTransition : nil
    }
    
    @objc func handlePanGesure(sender: UIPanGestureRecognizer) {
        //print("Navigation pan translation: \(sender.translation(in: view))")
    }
    
}

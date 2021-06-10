//
//  PhotoPresenterViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 23.04.2021.
//

import UIKit
import RealmSwift


class PhotoPresenterViewController: UIViewController {

    enum AnimationType {
        case foldFromRight
        case fold
        case rotate
    }
    enum AnimatorKind: CGFloat {
        case left = -1
        case right = 1
    }
    
    let animationType: AnimationType = .rotate
    var animatorKind: AnimatorKind?
    let maxPanDistance: CGFloat = 420
    lazy var mainImageView = UIImageView()
    lazy var secondImageView = UIImageView()
    var propertyAnimator: UIViewPropertyAnimator?
    var lastX: CGFloat = 0.0
    var centerX:CGFloat = 0.0
    var centerY: CGFloat = 0.0
    
    var transformRight = CATransform3D()
    var transformLeft = CATransform3D()
    
    var images: Results<VKRealmPhoto>?
    var currentImage: Int = 0
    var rect = CGRect.zero
    var targetFrame = CGRect.zero
    
    weak var interactiveTransition: PercentDrivenInteractiveTransition?
    var isZooming = false
    var currentImageScale : CGFloat = 1.0
    var lastTransform = CGAffineTransform()
 
    private var isHidedBars = false {
        didSet {
            isHidedBars ? hideBars() : showBars()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard images!.count > 0 else { return }
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panTrack))
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGR.name = "oneTap"
        tapGR.delegate = self
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTapGR.numberOfTapsRequired = 2
        doubleTapGR.name = "doubleTap"
        doubleTapGR.delegate = self
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        //doubleTapGR.n
        //let doubleTapGR = gestu
        view.addGestureRecognizer(panGR)
        view.addGestureRecognizer(tapGR)
        view.addGestureRecognizer(doubleTapGR)
        view.addGestureRecognizer(pinchGR)
        ImageLoader.getImage(from: images![currentImage].imageUrlString!) { image in
            let rect = self.calculateRect(image: image!)
            self.mainImageView.image = image!
            self.mainImageView.frame = rect
            self.mainImageView.bounds = rect
            print("Image in closure: \(image!)")
        }
        //rect = calculateRect(image: images[currentImage].image)
        print("rect is \(rect)")
        //rect = CGRect(x: 0, y: y, width: view.frame.width, height: height)
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isOpaque = false
        tabBarController?.tabBar.isHidden = false
        //mainImageView.image = images[currentImage].image
        
        print("mainImageView frame: \(mainImageView.frame)")
        mainImageView.contentMode = .scaleAspectFit
        print("mainImageView frame: \(mainImageView.frame)")
        view.backgroundColor = .clear
        centerX = mainImageView.center.x
        centerY = mainImageView.center.y
        view.addSubview(mainImageView)
        mainImageView.clipsToBounds = true
        if let navigationController = navigationController as? NavigationController {
            interactiveTransition = navigationController.interactiveTransition
        }
        print("mainImageView frame: \(mainImageView.frame)")
    }
    
    @objc func panTrack(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        
        switch sender.state {
        case .began:
            //Алгоритм:
            //Если есть аниматор, его надо завершить, чтоб обработался его комплишн блок, и удалить
            if propertyAnimator != nil {
                if propertyAnimator!.state == .active {
                    propertyAnimator!.stopAnimation(false)
                    propertyAnimator!.finishAnimation(at: UIViewAnimatingPosition.end) //Тут кажется может
                    //быть ошибка, если аниматор откатывал анимацию, а мы его завершили
                }
                propertyAnimator = nil
            }
            //Если перемещение началось по оси y, а по x нулевое - это смахивание и надо запустить pop
            if translation.y > 0 && translation.x == 0 && mainImageView
                .frame.minY >= 0 {
                
                interactiveTransition?.isStarted = true
                navigationController?.popViewController(animated: true)
                if let destination = navigationController?.topViewController as? FriendPhotosViewController {
                    let index = IndexPath(row: currentImage, section: 0)
                    //Move cell in collectionview into center
                    destination.collectionView.scrollToItem(at: index,
                                                            at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
                    targetFrame = destination.collectionView.layoutAttributesForItem(at: index)?.frame ?? CGRect.zero
                    let contentOffset = destination.collectionView.contentOffset
                    targetFrame.origin = CGPoint(x: targetFrame.minX, y: targetFrame.minY - contentOffset.y)
                    lastTransform = mainImageView.transform
                }
            }
        case .cancelled:
            //Наверное поскольку состояние неопределенное, надо удалить аниматор и все subview и вернуться к
            //состоянию как после viewDidLoad
            if let interactiveTransition = interactiveTransition,
               interactiveTransition.isStarted {
                interactiveTransition.isStarted = false
                interactiveTransition.cancel()
            }
            break
        
        case .changed:
            //Алгоритм:
            //Движение в минус/плюс:
            //1. Делаем левый/правый аниматор, если аниматор отсутствует
            //2. Двигаем анимацию в соответствии с перемещением.
            //Движение нулевое: если аниматор ненулевой - завершаем его и удаляем
            if isZooming {
                let centerPointsRectScale = currentImageScale - 1
                let dx = rect.width * (1 - centerPointsRectScale)
                let dy = rect.height * (1 - centerPointsRectScale)
                
                let centerPointsRect = rect.insetBy(dx: dx / 2, dy: dy / 2)
                
                let newCenter = CGPoint(x: centerX + translation.x,
                                        y: centerY + translation.y)
                print("dx=\(dx) dy=\(dy) centerPointsRectScale: \(centerPointsRectScale) centerPointsRect: \(centerPointsRect) newCenter: \(newCenter)")
                if centerPointsRect.contains(newCenter) {
                    print("cpr: minX: \(centerPointsRect.minX), maxX: \(centerPointsRect.maxX), minY: \(centerPointsRect.minY), maxY: \(centerPointsRect.maxY)")
                    mainImageView.center = newCenter
                    break
                } else if newCenter.y >= centerPointsRect.maxY {
                    //transitionable = true
                }
            }
            
            if let interactiveTransition = interactiveTransition,
               interactiveTransition.isStarted {
                let progress = max(0, translation.y / view.frame.height)
                mainImageView.center.x = centerX + translation.x
                mainImageView.center.y = centerY + translation.y
                let transform = CGAffineTransform(scaleX: 1 - progress / 2, y: 1 - progress / 2)
                mainImageView.transform = transform
                interactiveTransition.update(progress)
                interactiveTransition.shouldFinish = progress > 0 && velocity.y >= 0
                
            } else {
                switch translation.x {
                case var x where x < 0 && lastX <= 0:
                    lastX = x
                    if propertyAnimator == nil {
                        makeLeftAnimator()
                    }
                    x = x > -maxPanDistance ? x : -maxPanDistance
                    if currentImage == images!.count - 1 {
                        x = x / 2
                    }
                    propertyAnimator?.fractionComplete = x / -maxPanDistance
                case var x where x > 0 && lastX >= 0:
                    lastX = x
                    if propertyAnimator == nil {
                        makeRightAnimator()
                    }
                    x = x < maxPanDistance ? x : maxPanDistance
                    if currentImage == 0 {
                        x = x / 2
                    }
                    propertyAnimator?.fractionComplete = x / maxPanDistance
                default:
                    lastX = 0
                    if let propertyAnimator = propertyAnimator {
                        propertyAnimator.stopAnimation(false)
                        propertyAnimator.finishAnimation(at: UIViewAnimatingPosition.start)
                        self.propertyAnimator = nil
                    }
                }
                
            }
        case .ended:
            //Алгоритм:
            //Если движение нулевое и аниматор ненулевой - завершаем его и обнуляем
            //Если аниматор больше половины - завершаем его
            //Если меньше половины: если скорость больше предельной - завершаем, иначе - откатываем
            if let interactiveTransition = interactiveTransition,
               interactiveTransition.isStarted {
                interactiveTransition.isStarted = false
                interactiveTransition.shouldFinish ? {
                    interactiveTransition.pause()
                    UIView.animate(withDuration: 0.2, animations: { [self] in
                        mainImageView.center = CGPoint(x: targetFrame.midX, y: targetFrame.midY)
                        mainImageView.frame = targetFrame
                    }, completion: { _ in interactiveTransition.finish() }) }():
                    UIView.animate(withDuration: 0.2, animations: { [self] in
                        //mainImageView.center = view.center
                        //mainImageView.frame = rect
                        mainImageView.transform = lastTransform
                        mainImageView.center = view.center
                    }, completion: { _ in interactiveTransition.cancel()
                    })
                
            } else {
                centerX = mainImageView.center.x
                centerY = mainImageView.center.y
                let noReturnSpeed = maxPanDistance
                guard let propertyAnimator = propertyAnimator else { break }
                let x = translation.x
                let speed = velocity.x
                switch x {
                case let x where x != 0:
                    if (propertyAnimator.fractionComplete > 0.5  || //Если больше половины
                            abs(speed) > noReturnSpeed && speed * animatorKind!.rawValue > 0) && //Скорость больше предельной и соответствует направлению аниматора
                        !(currentImage == 0 && x > 0) && //Если не первая картинка и движение вправо
                        !(currentImage == images!.count - 1 && x < 0) //Если не последняя картинка и движение влево
                    {
                        let direction = x < 0 ? 1 : -1
                        propertyAnimator.addCompletion { [self] _ in
                            currentImage += direction
                            swap(&mainImageView, &secondImageView)
                            rect = mainImageView.frame
                            secondImageView.removeFromSuperview()
                            isZooming = false
                        }
                        propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    } else {
                        propertyAnimator.isReversed = true
                        propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    }
                case 0:
                    propertyAnimator.stopAnimation(false)
                    propertyAnimator.finishAnimation(at: UIViewAnimatingPosition.end)
                default:
                    print("Whatever")
                }
            }
            
        default:
            break
        }
    }

    
    func makeLeftAnimator() {
        animatorKind = .left
        secondImageView = UIImageView()
        secondImageView.frame = rect
        secondImageView.bounds = rect
        secondImageView.contentMode = .scaleAspectFit
        secondImageView.clipsToBounds = true
        if currentImage <= images!.count - 2 {
            ImageLoader.getImage(from: images![currentImage + 1].imageUrlString!) { image in
                self.secondImageView.image = image!
                self.secondImageView.frame = self.calculateRect(image: image!)
                self.secondImageView.bounds = self.calculateRect(image: image!)
            }
            //secondImageView.image = images[currentImage + 1].image
            //secondImageView.frame = calculateRect(image: images[currentImage + 1].image)
            //secondImageView.bounds = calculateRect(image: images[currentImage + 1].image)
        }
        let keyframes = makeKeyframes()
        secondImageView.layer.transform = keyframes[0].5
        view.addSubview(secondImageView)
        
        propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        propertyAnimator!.addAnimations {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: keyframes[0].0,
                                   relativeDuration: keyframes[0].1) {
                    self.mainImageView.layer.transform = keyframes[0].2
                }
                UIView.addKeyframe(withRelativeStartTime: keyframes[0].3,
                                   relativeDuration: keyframes[0].4) {
                    self.secondImageView.transform = .identity
                }
            }
        }

    }
    
    func makeRightAnimator() {
        animatorKind = .right
        secondImageView = UIImageView()
        secondImageView.frame = rect
        secondImageView.bounds = rect
        secondImageView.contentMode = .scaleAspectFit
        secondImageView.clipsToBounds = true
        //Если это первая картинка, то secondImageView будет пустой
        //Нельзя допусть завершение аниматора с currentImage == 0
        if currentImage > 0 {
            ImageLoader.getImage(from: images![currentImage - 1].imageUrlString!) { image in
                self.secondImageView.image = image!
                self.secondImageView.frame = self.calculateRect(image: image!)
                self.secondImageView.bounds = self.calculateRect(image: image!)
            }
            //secondImageView.image = images[currentImage-1].image
            //secondImageView.frame = calculateRect(image: images[currentImage-1].image)
            //secondImageView.bounds = calculateRect(image: images[currentImage-1].image)
        }
        let keyframes = makeKeyframes()
        secondImageView.layer.transform = keyframes[1].5
        view.addSubview(secondImageView)
        
        propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        propertyAnimator!.addAnimations {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear) {
                UIView.addKeyframe(withRelativeStartTime: keyframes[1].0,
                                   relativeDuration: keyframes[1].1) {
                    self.mainImageView.layer.transform = keyframes[1].2
                }
                UIView.addKeyframe(withRelativeStartTime: keyframes[1].3,
                                   relativeDuration: keyframes[1].4) {
                    self.secondImageView.transform = .identity
                }
            }
        }
    }
    
    @objc func doubleTapAction(sender: UITapGestureRecognizer) {

        let tapPoint = sender.location(in: view)

        guard mainImageView.frame.contains(tapPoint)
        else { return }

        if isZooming {
            UIView.animate(withDuration: 0.2) { [self] in
                mainImageView.transform = .identity
                mainImageView.center = view.center
            }
            currentImageScale = 1
            isZooming = false
            showBars()
        } else {
            currentImageScale = 2
            let transform = CGAffineTransform(scaleX: currentImageScale, y: currentImageScale)
            let dx = mainImageView.center.x - tapPoint.x
            let dy = mainImageView.center.y - tapPoint.y

            centerX = mainImageView.center.x + dx
            centerY = mainImageView.center.y + dy
            let newCenter = CGPoint(x: centerX + dx, y: centerY + dy)
            UIView.animate(withDuration: 0.2) { [self] in
                //self.mainImageView.frame = doubleFrame
                mainImageView.transform = transform
                mainImageView.center = newCenter
            }
            isZooming = true
            hideBars()
        }
    }
    
    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            centerX = mainImageView.center.x
            centerY = mainImageView.center.y
            hideBars()
        case .changed:
            if sender.numberOfTouches == 2 {
                var distanceX = sender.location(in: mainImageView).x - centerX
                var distanceY = sender.location(in: mainImageView).y - centerY
                print("location in change: \(sender.location(in: view))")
                print("number of touches: \(sender.numberOfTouches)")
                
                //print("distanceX = \(distanceX) distanceY = \(distanceY)")
                isZooming = true
                currentImageScale = currentImageScale * sender.scale
                print("newScale is \(currentImageScale)")
                if currentImageScale < 1 {
                    currentImageScale = 1
                }
                if currentImageScale > 6 {
                    currentImageScale = 6
                }
                var newDistanceX = distanceX * currentImageScale
                var newDistanceY = distanceY * currentImageScale
                var dx = newDistanceX - distanceX
                var dy = newDistanceY - distanceY
                let transform = CGAffineTransform(scaleX: currentImageScale, y: currentImageScale)
                mainImageView.transform = transform
                print("distanceX = \(distanceX) distanceY = \(distanceY) ")
                mainImageView.center.x = centerX + dx
                mainImageView.center.y = centerY + dy
                sender.scale = 1
                
            }
        case .ended:
            print("location in ended: \(sender.location(in: view))\n\n")
            print("number of touches: \(sender.numberOfTouches)")
            if mainImageView.frame.height < view.frame.height {
                UIView.animate(withDuration: 0.2) { [self] in
                    mainImageView.center.y = view.center.y
                }
            }
            if mainImageView.frame.width < view.frame.width {
                UIView.animate(withDuration: 0.2) { [self] in
                    mainImageView.center.x = view.center.x
                }
            }
        default:
            break
        }
    }
    
    @objc func tapAction() {

        isHidedBars.toggle()
        
    }
    
    private func hideBars() {
        if let navigationController = navigationController,
           let tabBarController = tabBarController {
    
            UIView.animate(withDuration: 0.2, animations: {
                [self] in
                    navigationController.navigationBar.isOpaque = true
                    tabBarController.tabBar.isOpaque = true
                    //mainImageView.frame = rect
            }, completion: { _ in
                navigationController.navigationBar.isHidden = true
                tabBarController.tabBar.isHidden = true
            })
        }
    }
    
    private func showBars() {
        if let navigationController = navigationController,
           let tabBarController = tabBarController {
            UIView.animate(withDuration: 0.2, animations: {
                [self] in
                    navigationController.navigationBar.isOpaque = false
                    tabBarController.tabBar.isOpaque = false
                    //mainImageView.frame = rect
            }, completion: { _ in
                navigationController.navigationBar.isHidden = false
                tabBarController.tabBar.isHidden = false
            })
        }
    }
    
    private func makeKeyframes() ->
    [(Double, Double, CATransform3D, Double, Double, CATransform3D)] {
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 900
        
        switch animationType {
        case let type where type == .fold || type == .foldFromRight:
            
            let translationZ = CATransform3DTranslate(transform, 0, 0, -200)
            let translationRight = CATransform3DTranslate(transform, 420, 0, 0)
            let translationLeft = CATransform3DTranslate(transform, -420, 0, 0)
            
            if type == .fold {
                return [(0.0, 0.5, translationZ, 0.5, 0.5, translationRight),
                    (0.0, 0.5, translationZ, 0.5, 0.5, translationLeft)]
            } else {
                return [(0.0, 0.5, translationZ, 0.5, 0.5, translationRight),
                    (0.0, 0.5, translationRight, 0.5, 0.5, translationZ)]
            }
            
            
            
        default:

            let rotationRight = CATransform3DRotate(transform, -.pi/1.85, 0, 1, 0)
            let translationRight = CATransform3DTranslate(transform, 400, 0, -400)
            transformRight = CATransform3DConcat(rotationRight, translationRight)
            
            let rotationLeft = CATransform3DRotate(transform, .pi/1.85, 0, 1, 0)
            let translationLeft = CATransform3DTranslate(transform, -400, 0, -400)
            transformLeft = CATransform3DConcat(rotationLeft, translationLeft)
            
            return [(0.0, 1.0, transformLeft, 0.0, 1.0, transformRight),
                    (0.0, 1.0, transformRight, 0.0, 1.0, transformLeft)]
            
            
        }
    }
    
    private func calculateRect(image: UIImage) -> CGRect {
        var y = CGFloat.zero
        var height = view.frame.height
        if let navigationController = navigationController,
           let tabBarController = tabBarController {
            y = navigationController.navigationBar.frame.minY + navigationController.navigationBar.frame.height
            height = tabBarController.tabBar.frame.minY - y
        }
        let imageScale = image.size.width / image.size.height
        let screenScale = view.frame.width / height
        if imageScale > screenScale {
            let scale = image.size.width / view.frame.width
            let dy = image.size.height / scale
            let rect = view.frame.insetBy(dx: 0, dy: (view.frame.height - dy) / 2)
            return rect
        } else {
            let scale = image.size.height / height
            let dx = image.size.width / scale
            let rect = view.frame.insetBy(dx: (view.frame.width - dx) / 2, dy: y / 2)
            return rect
        }
    }
    
}


extension PhotoPresenterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.name == "oneTap" && otherGestureRecognizer.name == "doubleTap" {
            return true
        } else {
            return false
        }
    }
}

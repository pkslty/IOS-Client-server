//
//  FriendView.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit

class FriendPhotosViewController: UICollectionViewController {

    var friend: Person?
    var friendNum: Int?
    var username: String?
    let animator = PushAnimation()
    var currentImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(friend)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "friendPhoto")
        //print(self.parent?.next)
        //navigationController?.delegate = self
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for cell in collectionView.visibleCells {
            guard let cell = cell as? FriendPhotoCell else { continue }
            //cell.animateDisappear()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        for cell in collectionView.visibleCells {
            guard let cell = cell as? FriendPhotoCell else { continue }
            //cell.animateAppear()
            /*let index = IndexPath(row: currentImage, section: 0)
            print(index)
            collectionView.scrollToItem(at: index, at: UICollectionView.ScrollPosition.centeredVertically, animated: false)*/
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FriendPhotoCell else { return }
        cell.animateAppear()
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (friend?.photos.count)!
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhoto", for: indexPath) as? FriendPhotoCell
        else { return UICollectionViewCell() }
        
        cell.config(image: (friend?.photos[indexPath.row].image)!,
                    likes: (friend?.photos[indexPath.row].likes)!,
                    tag: indexPath.row,
                    state: (friend?.photos[indexPath.row].likers.contains(username!))!)
        cell.likeButton.addTarget(self, action: #selector(likeButtonValueChanged(_:)), for: .valueChanged)
    
        return cell
    }
    
    @objc private func likeButtonValueChanged(_ likeButton: LikeButton) {
        friend?.photos[likeButton.tag].likes = likeButton.likes
        let _ = likeButton.isLiked ?
            friend?.photos[likeButton.tag].likers.insert(username!) :
            friend?.photos[likeButton.tag].likers.remove(username!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PhotoPresenterViewController
        else { return}
        destinationVC.images = friend!.photos
        destinationVC.currentImage = (collectionView.indexPathsForSelectedItems?.first!.row)!
        //destinationVC.navigationController = navigationController
        //destinationVC.transitioningDelegate = self
    }
    
}

extension FriendPhotosViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? FriendsViewController)?.user?.friends[friendNum!].photos = friend!.photos
    }
}

extension FriendPhotosViewController: UIViewControllerTransitioningDelegate {
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator
    }
    
}


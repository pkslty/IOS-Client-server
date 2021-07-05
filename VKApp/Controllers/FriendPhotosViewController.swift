//
//  FriendView.swift
//  VKApp
//
//  Created by Denis Kuzmin on 06.04.2021.
//

import UIKit
import RealmSwift

class FriendPhotosViewController: UICollectionViewController {

    enum UpdateRowsMethod {
        case update
        case delete
        case insert
    }
    
    var friend: VKRealmUser?
    var photos: Results<VKRealmPhoto>? {
        didSet {
            collectionView.reloadData()
        }
    }
    var friendNum: Int?
    var friendId = 0
    var username: String?
    let animator = PushAnimation()
    var currentImage = 0
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(friend)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "friendPhoto")
        //print(self.parent?.next)
        //navigationController?.delegate = self
        
        getPhotos()
        
        token = photos?.observe({ changes in
            switch changes {
            case .initial:
                self.collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.updateRows(for: modifications, method: .update)
                self.updateRows(for: deletions, method: .delete)
                self.updateRows(for: insertions, method: .insert)
            case .error(let error):
                print(error)
            }
        })

    }
    
    private func updateRows(for vkPhotosModificatedIndexes: [Int], method: UpdateRowsMethod) {
        var pathsToUpdate = [IndexPath]()
        vkPhotosModificatedIndexes.forEach { index in
            pathsToUpdate.append(IndexPath(row: index, section: 0))
        }
        guard pathsToUpdate.count > 0 else { return }
        switch method {
        case .update:
            collectionView.reloadItems(at: pathsToUpdate)
        case .delete:
            collectionView.deleteItems(at: pathsToUpdate)
        case .insert:
            collectionView.insertItems(at: pathsToUpdate)
        }
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
        updatePhotos()
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
        
        return (photos!.count)
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhoto", for: indexPath) as? FriendPhotoCell
        else { return UICollectionViewCell() }
        
        cell.config(image: (photos![indexPath.row]),
                    tag: indexPath.row)
        cell.likeButton.addTarget(self, action: #selector(likeButtonValueChanged(_:)), for: .valueChanged)
    
        return cell
    }
    
    @objc private func likeButtonValueChanged(_ likeButton: ActionButton) {
        /*friend?.photos[likeButton.tag].likes = likeButton.likes
        let _ = likeButton.isLiked ?
            friend?.photos[likeButton.tag].likers.insert(username!) :
            friend?.photos[likeButton.tag].likers.remove(username!)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PhotoPresenterViewController
        else { return}
        destinationVC.images = photos
        destinationVC.currentImage = (collectionView.indexPathsForSelectedItems?.first!.row)!
        //destinationVC.navigationController = navigationController
        //destinationVC.transitioningDelegate = self
    }
    
    private func getPhotos() {
        photos = try? RealmService.load(typeOf: VKRealmPhoto.self)
            .filter("ownerId == %i", friendId)
    }
    
    private func updatePhotos() {
        NetworkService.getPhotos(of: friendId) { [weak self] photos in
            print(photos)
            try? RealmService.save(items: photos)
            //self?.collectionView.reloadData()
        }
    }

    
    
}

extension FriendPhotosViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //(viewController as? FriendsViewController)?.user?.friends[friendNum!].photos = friend!.photos
    }
}

extension FriendPhotosViewController: UIViewControllerTransitioningDelegate {
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator
    }
    
}


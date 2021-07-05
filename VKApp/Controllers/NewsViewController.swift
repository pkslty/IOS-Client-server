//
//  NewsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 17.04.2021.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate{

    enum cellTypes: Int {
        case author = 0
        case repostAuthor = 1
        case text = 2
        case photo = 3
        case attachment = 4
        case actions = 5
        case link = 6
        case attachmentPhoto = 7
        case video = 8
    }
    struct cellDataDescription {
        var type: cellTypes
        var photoNum: Int?
        var attachmentNum: Int?
    }
    
    @IBOutlet weak var newsCollection: UICollectionView!
    var posts = [Post]()
    var vkNews = [VKNew]()
    var nextFrom = String()
    var postIsCollapsed = [Bool]()
    var cellType = [Int: Int]()
    //Dictionary for cells types:
    var cellsTypes = [Int: [Int: cellTypes]]()
    var cellsDataDesriptions = [Int: [Int: cellDataDescription]]()
    //var textCellHeightsThatFits = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsCollection.register(UINib(nibName: "NewsAuthorCell", bundle: nil), forCellWithReuseIdentifier: "NewsAuthorCell")
        newsCollection.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellWithReuseIdentifier: "NewsTextCell")
        newsCollection.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellWithReuseIdentifier: "NewsImageCell")
        newsCollection.register(UINib(nibName: "NewsActionsCell", bundle: nil), forCellWithReuseIdentifier: "NewsActionsCell")
        newsCollection.register(UINib(nibName: "NewsVideoCell", bundle: nil), forCellWithReuseIdentifier: "NewsVideoCell")
        
        NetworkService.performVkMethod(method: "newsfeed.get", with: ["count":"100", "filters":"post"]) { [weak self] data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            do {
                let response = (try JSONDecoder().decode(VKResponse<VKNewsFeed>.self, from: data)).response
                self?.vkNews = response.items
                self?.nextFrom = response.nextFrom ?? "none"
                //print("JSON: \(json)")
                print("VKNEWS: \(self?.vkNews)")
                self?.newsCollection.reloadData()
            } catch let error {
                print("error is \(error)")
            }
        }
        
        //newsCollection.backgroundColor = .systemBackground
        
        
    }
    

}

extension NewsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vkNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var cellType = [Int: cellTypes]()
        var cellDescriptor = [Int: cellDataDescription]()
        var photosNum = 0
        var currentItem = 0
        var numberOfItems = 1
        var vkNew: VKNew
        cellType[currentItem] = .author
        cellDescriptor[currentItem] = cellDataDescription(type: .author)
        if let repost = vkNews[section].copyHistory,
           repost.count > 0 {
            vkNew = repost.first!
            print(vkNew)
            currentItem += 1
            numberOfItems += 1
            cellDescriptor[currentItem] = cellDataDescription(type: .repostAuthor)
        } else {
            vkNew = vkNews[section]
        }
        if vkNew.text != nil {
            numberOfItems += 1
            currentItem += 1
            cellType[currentItem] = .text
            cellDescriptor[currentItem] = cellDataDescription(type: .text)
        }
        if let photos = vkNew.photos {
            photos.items.enumerated().forEach { (num, photo) in
                photosNum += 1
                numberOfItems += 1
                currentItem += 1
                cellType[currentItem] = .photo
                cellDescriptor[currentItem] = cellDataDescription(type: .photo, photoNum: num)
            }
        }
        if let attachments = vkNew.attachments {
            attachments.enumerated().forEach { (num, attachment) in
                switch attachment.type {
                case "photo":
                    numberOfItems += 1
                    currentItem += 1
                    cellType[currentItem] = .link
                    cellDescriptor[currentItem] = cellDataDescription(type: .attachmentPhoto, photoNum: num)
                case "link":
                    numberOfItems += 1
                    currentItem += 1
                    cellType[currentItem] = .link
                    cellDescriptor[currentItem] = cellDataDescription(type: .link, photoNum: num)
                case "video":
                    numberOfItems += 1
                    currentItem += 1
                    cellType[currentItem] = .link
                    cellDescriptor[currentItem] = cellDataDescription(type: .video, photoNum: num)
                default:
                    print("default")
                }
            }
        }
        numberOfItems += 1
        currentItem += 1
        cellType[currentItem] = .actions
        cellDescriptor[currentItem] = cellDataDescription(type: .actions)

        cellsTypes[section] = cellType
        cellsDataDesriptions[section] = cellDescriptor
        //print(cellsDataDesriptions)
        
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var plus: Int? = nil
        var vkNew: VKNew
        
        guard let cellDataDescription = cellsDataDesriptions[indexPath.section]?[indexPath.row]
        else { return UICollectionViewCell() }
        
        let isRepost = vkNews[indexPath.section].copyHistory != nil ? true : false
        if isRepost {
            vkNew = (vkNews[indexPath.section].copyHistory?.first!)!
            vkNew.sourceId = vkNew.ownerId
        }
        else {
            vkNew = vkNews[indexPath.section]
        }
        
        switch cellDataDescription.type {
        case .author:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsAuthorCell", for: indexPath) as? NewsAuthorCell
            
            else { return UICollectionViewCell() }
            
            
            if vkNews[indexPath.section].sourceId! > 0 {
                NetworkService.getUserById(id: vkNews[indexPath.section].sourceId!) { [weak self] user in
                    cell.configure(imageUrlString: user.first!.avatarUrlString, name: user.first!.fullName, date: (self?.vkNews[indexPath.section].date)!, isRepost: false)
                }
            }
            else {
                NetworkService.getGroupById(id: abs(vkNews[indexPath.section].sourceId!)) { [weak self] group in
                    cell.configure(imageUrlString: group.first!.photo200UrlString!, name: group.first!.name, date: (self?.vkNews[indexPath.section].date)!, isRepost: false)
                }
            }
            return cell
            
        case .repostAuthor:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsAuthorCell", for: indexPath) as? NewsAuthorCell
            
            else { return UICollectionViewCell() }
            
            
            if vkNew.sourceId! > 0 {
                NetworkService.getUserById(id: vkNew.sourceId!) { [weak self] user in
                    cell.configure(imageUrlString: user.first!.avatarUrlString, name: user.first!.fullName, date: vkNew.date, isRepost: isRepost)
                }
            }
            else {
                NetworkService.getGroupById(id: abs(vkNew.sourceId!)) { [weak self] group in
                    cell.configure(imageUrlString: group.first!.photo200UrlString!, name: group.first!.name, date: vkNew.date, isRepost: isRepost)
                }
            }
            
            
            return cell
        case .text:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell
                
            else { return UICollectionViewCell() }
                
            cell.configure(text: vkNew.text!)
                
            return cell
            
        case let type where type == .photo || type == .link || type == .attachment || type == .attachmentPhoto:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsImageCell", for: indexPath) as? NewsImageCell
            
            else { return UICollectionViewCell() }
            /*let rowdecr = posts[indexPath.section].text == nil ? 1 : 2
            if posts[indexPath.section].isImagesFolded && cellsTypes[indexPath.section]?[indexPath.row + 1] == 3 {
                plus = posts[indexPath.section].images.count - indexPath.row + rowdecr - 1
            }*/
            if type == .photo {
                cell.configure(imageUrlString: (vkNew.photos?.items[cellDataDescription.photoNum!].imageUrlString) ?? "none", plus: nil)
            }
            else {
                cell.configure(imageUrlString: (vkNew.attachments?[cellDataDescription.photoNum!].photo?.imageUrlString) ?? "none", plus: nil)
            }
            return cell
        case .actions:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsActionsCell", for: indexPath) as? NewsActionsCell
            
            else { return UICollectionViewCell() }
            
            cell.configure(likes: vkNews[indexPath.section].likes,
                           reposts: vkNews[indexPath.section].reposts,
                           tag: indexPath.section)
            
            return cell
        case .video:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsVideoCell", for: indexPath) as? NewsVideoCell
            
            else { return UICollectionViewCell() }
            
            let ownerId = String((vkNew
                .attachments?[cellDataDescription.photoNum!]
                .video?.ownerId)!)
            let id = String((vkNew
                .attachments?[cellDataDescription.photoNum!]
                .video?.id)!)
            let accessKey = String((vkNew
                .attachments?[cellDataDescription.photoNum!]
                .video?.accessKey)!)
            let videos = "\(ownerId)_\(id)_\(accessKey)"
            print("VIDEOS is \(videos)")
            NetworkService.performVkMethod(method: "video.get", with: ["owner_id":ownerId, "videos":videos]) { data in
                do {
                    let videos = try JSONDecoder().decode(VKResponse<VKItems<VKVideo>>.self, from: data)
                    let player = videos.response.items[0].player
                    print("player: \(player)")
                    cell.configure(videoUrlString: player ?? "none", plus: nil)
                } catch let error {
                    print("error is \(error)")
                }
            }

            
            return cell
        default:
            //break
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*if posts[indexPath.section].isImagesFolded {
            if let celltype = cellsTypes[indexPath.section]?[indexPath.row]{
                if celltype.rawValue == 3 {//image
                    for section in 0 ..< posts.count {
                        posts[section].isImagesFolded = true
                    }
                    posts[indexPath.section].isImagesFolded = false
                    newsCollection.reloadData()
                }
            }
        }
        if posts[indexPath.section].isTextFolded {
            if let celltype = cellsTypes[indexPath.section]?[indexPath.row]{
                if celltype.rawValue == 2 {//text
                    for section in 0 ..< posts.count {
                        posts[section].isTextFolded = true
                    }
                    posts[indexPath.section].isTextFolded = false
                    newsCollection.reloadData()
                }
            }
        }
        newsCollection.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
    */}
}



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
        
        let ns = NetworkService()
        ns.performVkMethod(method: "newsfeed.get", with: ["count":"100"]) { [weak self] data in
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
            
            //print(vkNews)
            //print(json)
        }
        
        
        
        // Do any additional setup after loading the view.
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
        cellType[currentItem] = .author
        cellDescriptor[currentItem] = cellDataDescription(type: .author)
        if vkNews[section].text != nil {
            numberOfItems += 1
            currentItem += 1
            cellType[currentItem] = .text
            cellDescriptor[currentItem] = cellDataDescription(type: .text)
        }
        if let photos = vkNews[section].photos {
            photos.items.enumerated().forEach { (num, photo) in
                photosNum += 1
                numberOfItems += 1
                currentItem += 1
                cellType[currentItem] = .photo
                cellDescriptor[currentItem] = cellDataDescription(type: .photo, photoNum: num)
            }
        }
        if let attachments = vkNews[section].attachments {
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
        guard let celltype = cellsTypes[indexPath.section]?[indexPath.row],
              let cellDataDescription = cellsDataDesriptions[indexPath.section]?[indexPath.row]
        else { return UICollectionViewCell() }
        let ns = NetworkService()
        switch cellDataDescription.type {
        case .author:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsAuthorCell", for: indexPath) as? NewsAuthorCell
            
            else { return UICollectionViewCell() }
            
            if vkNews[indexPath.section].sourceId > 0 {
                ns.getUserById(id: vkNews[indexPath.section].sourceId) { [weak self] user in
                    cell.configure(imageUrlString: user.first!.avatarUrlString, name: user.first!.fullName, date: (self?.vkNews[indexPath.section].date)!)
                }
            }
            else {
                ns.getGroupById(id: abs(vkNews[indexPath.section].sourceId)) { [weak self] group in
                    cell.configure(imageUrlString: group.first!.photo200UrlString!, name: group.first!.name, date: (self?.vkNews[indexPath.section].date)!)
                }
            }
            
            
            return cell
        case .text:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell
                
            else { return UICollectionViewCell() }
                
            cell.configure(text: vkNews[indexPath.section].text!)
                
            return cell
            
        case let type where type == .photo || type == .link || type == .attachment || type == .attachmentPhoto:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsImageCell", for: indexPath) as? NewsImageCell
            
            else { return UICollectionViewCell() }
            /*let rowdecr = posts[indexPath.section].text == nil ? 1 : 2
            if posts[indexPath.section].isImagesFolded && cellsTypes[indexPath.section]?[indexPath.row + 1] == 3 {
                plus = posts[indexPath.section].images.count - indexPath.row + rowdecr - 1
            }*/
            if type == .photo {
                cell.configure(imageUrlString: (vkNews[indexPath.section].photos?.items[cellDataDescription.photoNum!].imageUrlString) ?? "none", plus: nil)
            }
            else {
                cell.configure(imageUrlString: (vkNews[indexPath.section].attachments?[cellDataDescription.photoNum!].photo?.imageUrlString) ?? "none", plus: nil)
            }
            return cell
        case .actions:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsActionsCell", for: indexPath) as? NewsActionsCell
            
            else { return UICollectionViewCell() }
            
            cell.configure(likes: 10, tag: 1, state: true)
            
            return cell
        default:
            //break
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if posts[indexPath.section].isImagesFolded {
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
    }
}



//
//  NewsViewController.swift
//  VKApp
//
//  Created by Denis Kuzmin on 17.04.2021.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate{

    @IBOutlet weak var newsCollection: UICollectionView!
    var posts = [Post]()
    var postIsCollapsed = [Bool]()
    var cellType = [Int: Int]()
    //Dictionary for cells types:
    var cellsTypes = [Int: [Int: Int]]()
    //var textCellHeightsThatFits = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        
        newsCollection.register(UINib(nibName: "NewsAuthorCell", bundle: nil), forCellWithReuseIdentifier: "NewsAuthorCell")
        newsCollection.register(UINib(nibName: "NewsTextCell", bundle: nil), forCellWithReuseIdentifier: "NewsTextCell")
        newsCollection.register(UINib(nibName: "NewsImageCell", bundle: nil), forCellWithReuseIdentifier: "NewsImageCell")
        newsCollection.register(UINib(nibName: "NewsActionsCell", bundle: nil), forCellWithReuseIdentifier: "NewsActionsCell")
        
        
        
        // Do any additional setup after loading the view.
    }
    

    private func getPosts() {
        posts.append(Post(author: Person(firstname: "Иван", lastname: "Иванов"), date: DateComponents(), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore ", images: [UIImage(named: "man01")!, UIImage(named: "man02")!, UIImage(named: "man03")!, UIImage(named: "man04")!, UIImage(named: "woman01")!, UIImage(named: "woman02")!]))
        posts.append(Post(author: Person(firstname: "Петр", lastname: "Петров"), date: DateComponents(), text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", images: [UIImage(named: "man02")!, UIImage(named: "woman03")!, UIImage(named: "group01")!]))
        posts.append(Post(author: Person(firstname: "Петр", lastname: "Петров"), date: DateComponents(), text: "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?", images: [UIImage(named: "group01")!, UIImage(named: "woman02")!, UIImage(named: "group03")!, UIImage(named: "man05")!]))
    }

}

extension NewsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var cellType = [Int: Int]()
        //Минимум: Автор и количество лайков:
        var numberOfItems = 2
        cellType[0] = 0 //author
        if posts[section].text != nil {
            numberOfItems += 1
            cellType[1] = 1 //text
        }
        if posts[section].isImagesFolded {
            switch posts[section].images.count {
            case 1:
                numberOfItems += 1
            case 2, 3:
                numberOfItems += 2

            case let count where count >= 4:
                numberOfItems += 4
            default:
                break
            }
        } else {
            numberOfItems += posts[section].images.count
        }
        cellType[numberOfItems - 1] = 3 //actions
        for i in 2 ..< numberOfItems-1 {
            cellType[i] = 2 //image
        }
        cellsTypes[section] = cellType
        //print(cellsTypes)
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var plus: Int? = nil
        guard let celltype = cellsTypes[indexPath.section]?[indexPath.row]
        else { return UICollectionViewCell()}
        switch celltype {
        case 0:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsAuthorCell", for: indexPath) as? NewsAuthorCell
            
            else { return UICollectionViewCell() }
            
            cell.configure(image: (posts[indexPath.section].author.avatar ?? UIImage(systemName: "person.fill"))!, name: posts[indexPath.section].author.fullname, date: Date())
            
            return cell
        case 1:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsTextCell", for: indexPath) as? NewsTextCell
                
            else { return UICollectionViewCell() }
                
            cell.configure(text: posts[indexPath.section].text!)
                
            return cell
            
        case 2:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsImageCell", for: indexPath) as? NewsImageCell
            
            else { return UICollectionViewCell() }
            let rowdecr = posts[indexPath.section].text == nil ? 1 : 2
            if posts[indexPath.section].isImagesFolded && cellsTypes[indexPath.section]?[indexPath.row + 1] == 3 {
                plus = posts[indexPath.section].images.count - indexPath.row + rowdecr - 1
            }
            cell.configure(image: posts[indexPath.section].images[indexPath.row - rowdecr], plus: plus)
            return cell
        case 3:
            guard let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsActionsCell", for: indexPath) as? NewsActionsCell
            
            else { return UICollectionViewCell() }
            
            cell.configure(likes: 10, tag: 1, state: true)
            
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if posts[indexPath.section].isImagesFolded {
            if let celltype = cellsTypes[indexPath.section]?[indexPath.row]{
                if celltype == 2 {//image
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
                if celltype == 1 {//text
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



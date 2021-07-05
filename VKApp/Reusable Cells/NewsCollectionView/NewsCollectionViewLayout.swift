//
//  NewsCollectionViewLayout.swift
//  VKApp
//
//  Created by Denis Kuzmin on 18.04.2021.
//

import UIKit

class NewsCollectionViewLayout: UICollectionViewLayout {

    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()

    var columnsCount = 1
    let authorCellHeight: CGFloat = 60
    let actionsCellHeight: CGFloat = 30
    let textCellHeight: CGFloat = 128
    let cellInterval: CGFloat = 3
    //var section: Int

    private var totalCellsHeight: CGFloat = 0

    
    override func prepare() {
        self.cacheAttributes = [:]
     
        guard let collectionView = self.collectionView,
              let newsController = collectionView.delegate as? NewsViewController
        else { return }
        
        let sectionCount = collectionView.numberOfSections
        var lastY = CGFloat.zero
        for section in 0 ..< sectionCount {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            guard itemsCount > 1 else { return }
            
            let cellWidth = collectionView.frame.width
            let imageCellHeight = cellWidth
            //var firstImageInRow = true
            //var lastY = CGFloat.zero
            for index in 0 ..< itemsCount {
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let cellDataDescriptor = newsController.cellsDataDesriptions[section]?[index]
                switch cellDataDescriptor?.type {
                case .author, .repostAuthor:
                    attributes.frame = CGRect(x: 0, y: lastY + cellInterval, width: cellWidth, height: authorCellHeight)
                    lastY += authorCellHeight + cellInterval
                    
                //Last cell with likes, repost, etc
                case .actions:
                    attributes.frame = CGRect(x: 0, y: lastY + cellInterval, width: cellWidth, height: actionsCellHeight)
                    lastY += actionsCellHeight + cellInterval
                    
                //Cell with the text if the text exists
                case .text:
                    if let text = newsController.vkNews[section].copyHistory == nil ?
                        newsController.vkNews[section].text :
                        newsController.vkNews[section].copyHistory?.first?.text {
                    let cellHeightThatFits = UITextView.estimatedSize(text, targetSize: CGSize(width: cellWidth, height: .zero)).height
                    //newsController.textCellHeightsThatFits[section] = cellHeightThatFits
                    var cellHeight = textCellHeight
                        cellHeight = cellHeightThatFits + 20
                    /*if !newsController.vkNews[section].isTextFolded || textCellHeight > cellHeightThatFits {
                        cellHeight = cellHeightThatFits
                    }*/
                    attributes.frame = CGRect(x: 0, y: lastY + cellInterval, width: cellWidth, height: cellHeight)
                    lastY += cellHeight + cellInterval
                    }
                    
                case let type where type == .photo || type == .attachmentPhoto:
                    var imageHeight = CGFloat.zero
                    var vkNew: VKNew
                    let photoNum = cellDataDescriptor?.photoNum!
                        if newsController.vkNews[section].copyHistory != nil {
                            vkNew = (newsController.vkNews[section].copyHistory?.first!)!
                        }
                        else {
                            vkNew = newsController.vkNews[section]
                        }
                            if type == .photo {
                                let photo = vkNew.photos!.items[photoNum!]
                                imageHeight = photo.proportions * cellWidth
                        }
                            else {
                                let photo = vkNew.attachments![photoNum!].photo!
                                imageHeight = photo.proportions * cellWidth
                            }

                    attributes.frame = CGRect(x: 0, y: lastY + cellInterval, width: cellWidth, height: imageHeight)
                    lastY += imageHeight + cellInterval
                case .video:
                    attributes.frame = CGRect(x: 0, y: lastY + cellInterval, width: cellWidth, height: imageCellHeight)
                    lastY += imageCellHeight + cellInterval
                default:
                    /*if newsController.posts[section].isImagesFolded {
                        switch newsController.posts[section].images.count {
                        case 1:
                            attributes.frame = CGRect(x: 0, y: lastY, width: cellWidth, height: imageCellHeight)
                            lastY += imageCellHeight
                        case let count where count > 1:
                            if firstImageInRow {
                                attributes.frame = CGRect(x: 0, y: lastY, width: cellWidth / 2, height: imageCellHeight / 2)
                                firstImageInRow = false
                            } else {
                                attributes.frame = CGRect(x: cellWidth / 2, y: lastY, width: cellWidth / 2, height: imageCellHeight / 2)
                                lastY += imageCellHeight / 2
                                firstImageInRow = true
                            }
                        default:
                            print("default")
                            break
                        }
                    } else {
                        attributes.frame = CGRect(x: 0, y: lastY, width: cellWidth, height: imageCellHeight)
                        lastY += imageCellHeight
                    }*/
                    print("whatever")
                }
                totalCellsHeight = lastY
                cacheAttributes[indexPath] = attributes
            }
            lastY += 10
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0,
                      height: self.totalCellsHeight)
    }
}

extension UITextView {

   public static func estimatedSize(_ text: String, targetSize: CGSize) -> CGSize {
       let textView = UITextView(frame: .zero)
    textView.text = text
       return textView.sizeThatFits(targetSize)
   }
}

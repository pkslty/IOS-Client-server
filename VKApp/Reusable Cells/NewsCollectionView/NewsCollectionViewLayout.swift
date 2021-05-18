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
            var firstImageInRow = true
            //var lastY = CGFloat.zero
            for index in 0 ..< itemsCount {
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                switch index {
                //Author name and date
                case 0:
                    attributes.frame = CGRect(x: 0, y: lastY, width: cellWidth, height: authorCellHeight)
                    lastY += authorCellHeight
                    
                //Last cell with likes, repost, etc
                case let count where count == itemsCount - 1:
                    attributes.frame = CGRect(x: 0, y: lastY, width: cellWidth, height: actionsCellHeight)
                    lastY += actionsCellHeight
                    
                //Cell with the text if the text exists
                case 1 where newsController.posts[section].text != nil:
                    let cellHeightThatFits = UILabel.estimatedSize(newsController.posts[section].text!, targetSize: CGSize(width: cellWidth, height: .zero)).height
                    //newsController.textCellHeightsThatFits[section] = cellHeightThatFits
                    var cellHeight = textCellHeight
                    if !newsController.posts[section].isTextFolded || textCellHeight > cellHeightThatFits {
                        cellHeight = cellHeightThatFits
                    }
                    attributes.frame = CGRect(x: 0, y: lastY, width: cellWidth, height: cellHeight)
                    lastY += cellHeight
                    
                //All other cells with images
                default:
                    if newsController.posts[section].isImagesFolded {
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
                    }
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

extension UILabel {

   public static func estimatedSize(_ text: String, targetSize: CGSize) -> CGSize {
       let label = UILabel(frame: .zero)
       label.numberOfLines = 0
       label.text = text
       return label.sizeThatFits(targetSize)
   }
}

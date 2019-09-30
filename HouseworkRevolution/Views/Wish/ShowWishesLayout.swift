//
//  ShowWishesLayout.swift
//  HouseworkRevolution
//
//  Created by Sylvia Jia Fen  on 2019/9/2.
//  Copyright © 2019 Sylvia Jia Fen . All rights reserved.
//

import UIKit

class ShowWishesLayout: UICollectionViewLayout {
    
    weak var delegate: ShowWishesLayoutDelegate?
    
    fileprivate var numberOfColumns = 2
    
    fileprivate var cellPadding: CGFloat = 10

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
       
        cache.removeAll()
        
        guard let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset = [CGFloat]()
        
        for column in 0 ..< numberOfColumns {
            
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            guard let itemHeight = delegate?.collectionView(_collectionView: collectionView,
                                                            heightForItemAtIndexPath: indexPath) else { return }
            
            let height = cellPadding * 2 + itemHeight
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = insetFrame
            
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            
            yOffset[column] += height
            
            if column < numberOfColumns - 1 {
                
                column += 1
                
            } else {
                
                column = 0
            }
        }
    }
    
    override func layoutAttributesForElements(
        in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            
            if attributes.frame.intersects(rect) {
                
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(
        at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cache[indexPath.item]
    }
}

protocol ShowWishesLayoutDelegate: AnyObject {
    
    func collectionView(_collectionView: UICollectionView,
                        heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

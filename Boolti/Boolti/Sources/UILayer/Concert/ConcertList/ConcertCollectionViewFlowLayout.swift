//
//  ConcertCollectionViewFlowLayout.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/9/24.
//

import UIKit

final class ConcertCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: Properties

    var stickyIndexPath: IndexPath? {
        didSet {
            self.invalidateLayout()
        }
    }
    
    // MARK: Init
    
    required init(stickyIndexPath: IndexPath?) {
        super.init()
        
        self.stickyIndexPath = stickyIndexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        if let stickyAttributes = getStickyAttributes(at: stickyIndexPath) {
            layoutAttributes?.append(stickyAttributes)
        }
        
        return layoutAttributes
    }
    
    private func getStickyAttributes(at indexPath: IndexPath?) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView,
              let stickyIndexPath = indexPath,
              let stickyAttributes = layoutAttributesForItem(at: stickyIndexPath)?.copy() as? UICollectionViewLayoutAttributes
              else {
            return nil
        }
        
        if collectionView.contentOffset.y > stickyAttributes.frame.minY {
            var frame = stickyAttributes.frame
            frame.origin.y = collectionView.contentOffset.y
            stickyAttributes.frame = frame
            stickyAttributes.zIndex = 1
            return stickyAttributes
        }
        return nil
    }
}

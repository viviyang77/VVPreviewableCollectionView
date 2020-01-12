//
//  VVPreviewableCollectionView.swift
//  VVPreviewableCollectionView
//
//  Created by Vivi on 2020/1/12.
//  Copyright © 2020 Vivi Yang. All rights reserved.
//

import UIKit

/// A UICollectionView that shows a part of the previous and next cell of the currently centered cell.
class VVPreviewableCollectionView: UICollectionView {

    // MARK: - Public variables

    /// The width of the visible part of the previous/next cell. The default value is 30.
    var previewWidth: CGFloat = 30
    
    /// The spacing between cells. The default value is 20.
    var cellSpacing: CGFloat = 20
    
    /// The handler that will be called when a cell is scrolled to.
    /// The index of that selected cell is passed as a parameter.
    var scrolledToIndexHandler: ((_ selectedIndex: Int) -> Void)?
    
    var cellWidth: CGFloat {
        return frame.size.width - (cellSpacing + previewWidth) * 2
    }
    
    // MARK: - Private variables
    
    private var maxIndex: Int {
        return numberOfItems(inSection: 0) - 1
    }
    
    private var currentIndex: Int = 0
    private var currentContentOffsetX: CGFloat = 0  // Used to determine the scrolling direction
    
    // MARK: - Functions
    
    func setup() {
        isPagingEnabled = false
        contentInset = UIEdgeInsets(top: 0, left: previewWidth + cellSpacing, bottom: 0, right: cellSpacing)
        decelerationRate = .fast
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func cellSize() -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        
        return CGSize(width: cellWidth, height: frame.size.height)
    }
    
    func targetContentOffset(velocity: CGPoint,
                             previousTargetOffset: CGPoint) -> CGPoint {
                
        let targetY = previousTargetOffset.y    // y won't change
        var targetIndex = 0
        
        // If velocity is fast enough, increase/decrease index directly without calculating frames.
        if velocity.x > 0 {
            targetIndex = min(currentIndex + 1, maxIndex)
        } else if velocity.x < 0 {
            targetIndex = max(currentIndex - 1, 0)
        } else {
            // The point we test which item should be scrolled to is the middle of a cell.
            // Therefore we need to add certain distance to test if the center of the next/previous cell is visible.
            let isScrollingToNext = previousTargetOffset.x > currentContentOffsetX
            let distanceToAdd =
                isScrollingToNext
                    ? previewWidth + cellSpacing + cellWidth / 2.0
                    : cellSpacing   // In case that user scrolls to the space between two cells
            
            let targetPoint = CGPoint(x: previousTargetOffset.x + distanceToAdd,
                                      y: targetY)
            targetIndex = indexPathForItem(at: targetPoint)?.item ?? currentIndex
        }
        
        let targetX = cellWidth * CGFloat(targetIndex) + cellSpacing * CGFloat(targetIndex - 1) - previewWidth
        
        currentIndex = targetIndex
        currentContentOffsetX = targetX

        scrolledToIndexHandler?(targetIndex)
        
        return CGPoint(x: targetX, y: targetY)
    }
}

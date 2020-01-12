# VVPreviewableCollectionView
A UICollectionView that shows a part of the previous and next cell of the currently centered cell.

<img src="https://i.imgur.com/weFSBFI.gif" data-canonical-src="VVPreviewableCollectionView" width="400" />

## Usage

### Setup

```
collectionView.previewWidth = 30
collectionView.cellSpacing = 15
collectionView.scrolledToIndexHandler = { (selectedIndex: Int) in
    print("Scrolled to cell #\(selectedIndex)")
}
```

### UIScrollViewDelegate

Change your `scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)` to the following:

```
func scrollViewWillEndDragging(_ scrollView: UIScrollView, 
                               withVelocity velocity: CGPoint, 
                               targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    guard scrollView == collectionView else { return }
    
    // Use PreviewableCollectionView's function to calculate the target contentOffset
    let target = collectionView.targetContentOffset(velocity: velocity,
                                                    previousTargetOffset: targetContentOffset.pointee)
    targetContentOffset.pointee = target
}
```

### UICollectionViewDelegateFlowLayout

Change your UICollectionViewDelegateFlowLayout methods to the following:

```
func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: self.collectionView.cellWidth,
                  height: collectionView.frame.height)
}

func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return self.collectionView.cellSpacing
}

func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return self.collectionView.cellSpacing
}
```

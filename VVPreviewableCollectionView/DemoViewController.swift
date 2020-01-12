//
//  DemoViewController.swift
//  VVPreviewableCollectionView
//
//  Created by Vivi on 2020/1/12.
//  Copyright © 2020 Vivi Yang. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    private lazy var collectionView: VVPreviewableCollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = VVPreviewableCollectionView(frame: .zero,
                                                         collectionViewLayout: layout)
        collectionView.setup()
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.previewWidth = 30
        collectionView.cellSpacing = 15
        collectionView.scrolledToIndexHandler = { (selectedIndex: Int) in
            print("Scrolled to cell #\(selectedIndex)")
        }
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        [collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
         collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
         collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
         collectionView.heightAnchor.constraint(equalToConstant: 200)
            ].forEach { $0.isActive = true }
        
        // For demo purpose
        collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
}

extension DemoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let customCell = cell as? CollectionViewCell {
            customCell.setupData(text: "\(indexPath.item)")
        }
        return cell
    }
}

extension DemoViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == collectionView else { return }
        
        // Use PreviewableCollectionView's function to calculate the target contentOffset
        let target = collectionView.targetContentOffset(velocity: velocity,
                                                        previousTargetOffset: targetContentOffset.pointee)
        targetContentOffset.pointee = target
    }
        
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
}

class CollectionViewCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        clipsToBounds = true
        layer.cornerRadius = 15
        backgroundColor = UIColor(red: getRandomColorComponent(),
                                  green: getRandomColorComponent(),
                                  blue: getRandomColorComponent(),
                                  alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
    
    func setupData(text: String?) {
        label.text = text
    }
        
    private func getRandomColorComponent() -> CGFloat {
        return CGFloat(arc4random_uniform(255)) / 255.0
    }
}

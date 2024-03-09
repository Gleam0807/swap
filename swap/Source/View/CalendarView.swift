//
//  CanledarView.swift
//  swap
//
//  Created by SUNG on 3/5/24.
//

import UIKit

class CalendarView: UIView {
    // MARK: Metric
    enum Metric {
        static let collectionViewHeight: CGFloat = 90
        static let cellWidth: CGFloat = UIScreen.main.bounds.width
    }
    
    // MARK: Initailizer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: UI
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: Metric.cellWidth, height: Metric.collectionViewHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
      }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calndarCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: Configure
    func configure() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

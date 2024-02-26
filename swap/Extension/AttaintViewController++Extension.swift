//
//  AttaintViewController++Extension.swift
//  swap
//
//  Created by SUNG on 2/25/24.
//

import UIKit

extension AttaintViewController {
    final class CalendarCollectionViewCell: UICollectionViewCell {
        let monthButtonBackgroundColor: UIColor? = .swapButtonColor
        let monthButtonTextColor: UIColor? = .swapTextColor
        
        // MARK: UI
        private let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let yearLabel: UILabel = {
            let label = UILabel()
            label.textColor = .swapTextColor
            label.backgroundColor = .swapInputColor
            label.font = .swapTitleTextFont
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        /// Container of year & month buttons
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 4
            stackView.alignment = .top
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        /// Month list
        private let topMonthStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.backgroundColor = .swapInputColor
            stackView.axis = .horizontal
            stackView.spacing = 16
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private let bottomMonthStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.backgroundColor = .swapInputColor
            stackView.axis = .horizontal
            stackView.spacing = 16
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        let janButton: UIButton = {
            let button = UIButton()
            button.setTitle("1월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let febButton: UIButton = {
            let button = UIButton()
            button.setTitle("2월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let marButton: UIButton = {
            let button = UIButton()
            button.setTitle("3월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let aprButton: UIButton = {
            let button = UIButton()
            button.setTitle("4월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let mayButton: UIButton = {
            let button = UIButton()
            button.setTitle("5월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let junButton: UIButton = {
            let button = UIButton()
            button.setTitle("6월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let julButton: UIButton = {
            let button = UIButton()
            button.setTitle("7월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let augButton: UIButton = {
            let button = UIButton()
            button.setTitle("8월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let sepButton: UIButton = {
            let button = UIButton()
            button.setTitle("9월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let octButton: UIButton = {
            let button = UIButton()
            button.setTitle("10월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let novButton: UIButton = {
            let button = UIButton()
            button.setTitle("11월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let decButton: UIButton = {
            let button = UIButton()
            button.setTitle("12월", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            prepare(nil)
        }
        
        func prepare(_ text: String?) {
            yearLabel.text = text
        }
        
        func configure() {
            // addSubview
            contentView.addSubview(containerView)
            containerView.addSubview(containerStackView)
            containerStackView.addArrangedSubview(yearLabel)
            containerStackView.addArrangedSubview(topMonthStackView)
            containerStackView.addArrangedSubview(bottomMonthStackView)
            
            let topMonthButtons = [
                janButton, febButton, marButton,
                aprButton, mayButton, junButton
            ]
            let bottomMonthButtons = [
                julButton, augButton, sepButton,
                octButton, novButton, decButton
            ]
            topMonthButtons.forEach {
                $0.backgroundColor = monthButtonBackgroundColor
                $0.titleLabel?.font = .swapTextFont
                $0.setTitleColor(monthButtonTextColor, for: .normal)
                topMonthStackView.addArrangedSubview($0)
            }
            bottomMonthButtons.forEach {
                $0.backgroundColor = monthButtonBackgroundColor
                $0.titleLabel?.font = .swapTextFont
                $0.setTitleColor(monthButtonTextColor, for: .normal)
                bottomMonthStackView.addArrangedSubview($0)
            }
            
            // containerView
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            
            // yearLabel
            NSLayoutConstraint.activate([
                yearLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
                yearLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
            ])
            
            // containerStackView
            NSLayoutConstraint.activate([
                containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
                containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            // monthStackView
            NSLayoutConstraint.activate([
                topMonthStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
                topMonthStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
                bottomMonthStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
                bottomMonthStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)
            ])
            
            // month buttons
            topMonthButtons.forEach {
                NSLayoutConstraint.activate([
                    $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 0.6)
                ])
            }
            
            bottomMonthButtons.forEach {
                NSLayoutConstraint.activate([
                    $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 0.6)
                ])
            }
        }
    }

    class CalendarView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            configure()
        }
        
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
            collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.isPagingEnabled = true
            return collectionView
        }()
        
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
}

//
//  TrophyViewController.swift
//  swap
//
//  Created by SUNG on 2/1/24.
//

import UIKit

class TrophyViewController: UIViewController {
    // MARK: Properties
    let imageLabelList: [String] = ["1회 방문기념", "30회 방문기념", "100회 방문기념", "200회 방문기념", "300회 방문기념"]
    var imageViewList: [UIImage] = []
    
    // MARK: Outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        visitImageAppend()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        visitImageAppend()
    }
    
    //MARK: Function
    func visitImageAppend() {
        let visitCount = VisitManager.shared.getVisitCount()
        
        // 1회 방문기념
        if visitCount >= 1 {
            if let image = UIImage(named: "visitTrophyFirst") {
                imageViewList.append(image)
            }
        }
        
        // 30회 방문기념
        if visitCount >= 30 {
            if let image = UIImage(named: "visitTrophySecond") {
                imageViewList.append(image)
            }
        }
        
        // 100회 방문기념
        if visitCount >= 100 {
            if let image = UIImage(named: "visitTrophyThird") {
                imageViewList.append(image)
            }
        }
        
        // 200회 방문기념
        if visitCount >= 200 {
            if let image = UIImage(named: "visitTrophyFourth") {
                imageViewList.append(image)
            }
        }
        
        // 300회 방문기념
        if visitCount >= 300 {
            if let image = UIImage(named: "visitTrophyFifth") {
                imageViewList.append(image)
            }
        }
    }
    
    func presentTabBar(withIdentifier identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false)
        }
    }
    
}

extension TrophyViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[0] {
            presentTabBar(withIdentifier: "MainViewController")
        } else if item == tabBar.items?[1] {
            presentTabBar(withIdentifier: "AttaintViewController")
        }
    }
}

// MARK: UICollectionViewDelegate
extension TrophyViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDataSource
extension TrophyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrohpyCollectionViewCell", for: indexPath) as? TrohpyCollectionViewCell else { return UICollectionViewCell() }
        cell.firstImage.image = imageViewList[indexPath.item]
        cell.trohpyLabel.text = imageLabelList[indexPath.row]
        return cell
    }
}


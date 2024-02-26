//
//  TrophyViewController.swift
//  swap
//
//  Created by SUNG on 2/1/24.
//

import UIKit

class TrophyViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        tabBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: Function
    func presentTabBar(withIdentifier identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[0] {
            presentTabBar(withIdentifier: "MainViewController")
        } else if item == tabBar.items?[1] {
            presentTabBar(withIdentifier: "AttaintViewController")
        } else if item == tabBar.items?[2] {
     
        }
    }
}

extension TrophyViewController: UITabBarDelegate {
    
}

extension TrophyViewController: UICollectionViewDelegate {
    
}

extension TrophyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrohpyCollectionViewCell", for: indexPath) as! TrohpyCollectionViewCell
        //cell.firstImage.image = UIImage(named: "swap_splash")
        return cell
    }
}

class TrohpyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstImage: UIImageView!
}

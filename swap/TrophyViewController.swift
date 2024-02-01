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
    
    override func viewDidLoad() {
        tabBar.delegate = self
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

//
//  AttaintViewController.swift
//  swap
//
//  Created by SUNG on 2/1/24.
//

import UIKit

class AttaintViewController: UIViewController {
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
            
        } else if item == tabBar.items?[2] {
            presentTabBar(withIdentifier: "TrophyViewController")
        }
    }
}

extension AttaintViewController: UITabBarDelegate {
    
}

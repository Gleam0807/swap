//
//  MainViewController.swift
//  swap
//
//  Created by SUNG on 1/29/24.
//

import UIKit

class MainViewController: UIViewController {
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
            
        } else if item == tabBar.items?[1] {
            presentTabBar(withIdentifier: "AttaintViewController")
        } else if item == tabBar.items?[2] {
            presentTabBar(withIdentifier: "TrophyViewController")
        }
    }
    
    //MARK: Action
    @IBAction func calendarAddButtonClicked(_ sender: UIButton) {
        //CalendarAddViewController
        if let calendarAddVC = storyboard?.instantiateViewController(withIdentifier: "CalendarAddViewController") {
            present(calendarAddVC, animated: true)
        }
    }
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        if let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingModalViewController") {
            present(settingVC, animated: true)
        }
    }
    
}

extension MainViewController: UITabBarDelegate {
    
}

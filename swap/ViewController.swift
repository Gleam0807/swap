//
//  ViewController.swift
//  swap
//
//  Created by SUNG on 1/27/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: function
    func saveUserDefaults(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key) // 값 저장
    }
    
    func fetchUserDefaults(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key) // 값 가져오기
    }
    
    // MARK: Action
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if let suggestionVC = storyboard?.instantiateViewController(withIdentifier: "SuggestionViewController") {
            suggestionVC.modalPresentationStyle = .fullScreen
            present(suggestionVC, animated: true)
        }
    }
    
}


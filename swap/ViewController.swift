//
//  ViewController.swift
//  swap
//
//  Created by SUNG on 1/27/24.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var nickNameField: UITextField!

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
        guard let nickname = nickNameField.text, !nickname.isEmpty else {
            nickNameField.placeholder = "닉네임을 입력해주세요."
            return
        }
        
        saveUserDefaults(key: "nickname", value: nickname)
    
        if let suggestionVC = storyboard?.instantiateViewController(withIdentifier: "SuggestionViewController") {
            nickNameField.text = ""
            suggestionVC.modalPresentationStyle = .fullScreen
            present(suggestionVC, animated: true)
        }
    }
    
}


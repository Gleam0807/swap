//
//  ViewController.swift
//  swap
//
//  Created by SUNG on 1/27/24.
//

import UIKit
import RealmSwift

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
            let alert = UIAlertController(title: "올바르지 않은 닉네임", message: "닉네임을 다시 입력해주세요.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }
        
        //saveUserDefaults(key: "nickname", value: nickname)
    
        if let suggestionVC = storyboard?.instantiateViewController(withIdentifier: "SuggestionViewController") {
            nickNameField.text = ""
            suggestionVC.modalPresentationStyle = .fullScreen
            present(suggestionVC, animated: true)
        }
    }
    
}


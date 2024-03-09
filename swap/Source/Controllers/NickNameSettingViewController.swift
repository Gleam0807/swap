//
//  NickNameSettingViewController.swift
//  swap
//
//  Created by SUNG on 1/27/24.
//

import UIKit
import RealmSwift

class NickNameSettingViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var nickNameField: UITextField!

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
    }
    
    // MARK: Functions
    func saveNickname(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: Action
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        guard let nickname = nickNameField.text, !nickname.isEmpty else {
            presentAlert(title: "올바르지 않은 닉네임", message: "닉네임을 다시 입력해주세요.")
            return
        }
        
        guard let suggestionVC = storyboard?.instantiateViewController(withIdentifier: "SuggestionViewController") else { return }
        saveNickname(key: "nickname", value: nickname)
        nickNameField.text = ""
        suggestionVC.modalPresentationStyle = .fullScreen
        present(suggestionVC, animated: true)
    }
}


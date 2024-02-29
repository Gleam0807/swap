//
//  SettingModalViewController.swift
//  swap
//
//  Created by SUNG on 1/31/24.
//

import UIKit
import MessageUI

class SettingModalViewController: UIViewController {
    var nickNameUpdateDelegate: NickNameUpdateDelegate!
    //MARK: Outlet
    @IBOutlet weak var nicknameSettingLabel: UITextField!
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? 1.0    // 앱 버전
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
    }
    
    //MARK: Action
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let nickname = nicknameSettingLabel.text, !nickname.isEmpty else {
            let alert = UIAlertController(title: "올바르지 않은 닉네임", message: "닉네임을 다시 입력해주세요.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }

        UserDefaults.standard.set(nickname, forKey: "nickname")
        nickNameUpdateDelegate.nickNameUpdate()
        self.dismiss(animated: true)
    }
    
    @IBAction func detailInfoButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "앱 정보", message: "Version: \(appVersion)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func inquiryButtonClicked(_ sender: Any) {
        
    }
    
}

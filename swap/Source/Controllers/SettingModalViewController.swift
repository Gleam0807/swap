//
//  SettingModalViewController.swift
//  swap
//
//  Created by SUNG on 1/31/24.
//

import UIKit
import MessageUI

class SettingModalViewController: UIViewController {
    // MARK: Properties
    var UpdateNickNameDelegate: UpdateNickNameDelegate!
    
    // MARK: Outlets
    @IBOutlet weak var nicknameSettingLabel: UITextField!
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? 1.0
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        dismissKeyboard()
    }
    
    // MARK: Actions
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let nickname = nicknameSettingLabel.text, !nickname.isEmpty else {
            presentAlert(title: "올바르지 않은 닉네임", message: "닉네임을 다시 입력해주세요.")
            return
        }

        UserDefaults.standard.set(nickname, forKey: "nickname")
        UpdateNickNameDelegate.updateNickName()
        self.dismiss(animated: true)
    }
    
    @IBAction func detailInfoButtonClicked(_ sender: Any) {
        presentAlert(title: "앱 정보", message: "Version: \(appVersion)")
    }
    
    @IBAction func inquiryButtonClicked(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            let bodyString = ""
            
            composeVC.setToRecipients(["teemocscsg@gmail.com"])
            composeVC.setSubject("문의 사항")
            composeVC.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeVC, animated: true)
        } else {
            // 만약, 디바이스에 email 기능이 비활성화 일 때, 사용자에게 알림
            let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
                guard let mailSettingsURL = URL(string: UIApplication.openSettingsURLString + "&&path=MAIL") else { return }
                if UIApplication.shared.canOpenURL(mailSettingsURL) {
                    UIApplication.shared.open(mailSettingsURL, options: [:], completionHandler: nil)
                }
            }
            presentAlert(title: "메일 계정 활성화 필요", message: "Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.", alertAction: alertAction)
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension SettingModalViewController: MFMailComposeViewControllerDelegate {
    // TODO: 메일 전송 성공여부 얼럿 추가
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("메일 보내기 성공")
        case .cancelled:
            print("메일 보내기 취소")
        case .saved:
            print("메일 임시 저장")
        case .failed:
            print("메일 발송 실패")
        @unknown default: break
        }
        
        self.dismiss(animated: true)
    }
}

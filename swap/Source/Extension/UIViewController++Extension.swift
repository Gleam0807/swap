//
//  UIViewController++Extension.swift
//  swap
//
//  Created by SUNG on 2/18/24.
//

import UIKit

extension UIViewController {
    func isDateInRange(startDate: Date, endDate: Date, target: Date) -> Bool {
        let isStarted = startDate <= target
        let isEnd = endDate < target
        return startDate == endDate ? true : isStarted && !isEnd
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(title: String, message: String, buttonTitle: String = "확인", alertAction: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alertAction = alertAction {
            alert.addAction(alertAction)
        } else {
            let okButton = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            alert.addAction(okButton)
        }
        present(alert, animated: true, completion: nil)
    }
}

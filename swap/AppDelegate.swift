//
//  AppDelegate.swift
//  swap
//
//  Created by SUNG on 1/27/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "nickname")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController?
        
        if name == nil {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            //initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        VisitManager.shared.increaseVisitCountIfNeeded()
        
        requestNotificationAuthorization()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

class VisitManager {
    static let shared = VisitManager()
    let userDefaults = UserDefaults.standard
    let visitCountKey = "visitCount"
    let lastVisitDateKey = "lastVisitDate"
    
    private init() {}
    
    func increaseVisitCountIfNeeded() {
        let lastVisitDate = userDefaults.object(forKey: lastVisitDateKey) as? Date
        let currentDate = Date()
        
        // 이전 방문 날짜가 없거나 오늘과 다른 날짜라면 방문 횟수 증가
        if lastVisitDate == nil || !Calendar.current.isDate(currentDate, inSameDayAs: lastVisitDate!) {
            var visitCount = userDefaults.integer(forKey: visitCountKey)
  
            if visitCount == 0 {
                visitCount = 1
            } else {
                visitCount += 1
            }
            userDefaults.set(visitCount, forKey: visitCountKey)
            userDefaults.set(currentDate, forKey: lastVisitDateKey) // 방문 날짜 갱신
        }
    }
    
    func getVisitCount() -> Int {
        return userDefaults.integer(forKey: visitCountKey)
    }
    
    func resetVisitCount() {
        userDefaults.removeObject(forKey: visitCountKey)
        userDefaults.removeObject(forKey: lastVisitDateKey)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

func requestNotificationAuthorization() {
    let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)

    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
        if let error = error {
            print("Error: \(error)")
        }
    }
}

//MARK:- IBInspectable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

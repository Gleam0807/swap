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
        let name = UserDefaults.standard.string(forKey: "nickname")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController?
        
        if name == nil {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "NickNameSettingViewController") as! NickNameSettingViewController
            /// - NOTE: 닉네임 설정단계 패스하고 메인뷰로 넘어가는 테스트용 코드
            //initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        VisitManager.shared.increaseVisitCountIfNeeded()
        
        requestNotificationAuthorization()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

func requestNotificationAuthorization() {
    let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)

    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
        if let error = error {
            print("Error: \(error)")
        }
    }
}

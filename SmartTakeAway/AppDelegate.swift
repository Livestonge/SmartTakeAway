//
//  AppDelegate.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 22/07/2022.
//

import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent _: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if #available(iOS 14, *) {
            completionHandler(.banner)
        } else {
            completionHandler(.alert)
        }
    }
}

extension UIView {
//    Method for automating the add subview process.
    func addSubView(view: UIView, constraintTo anchorView: UIView) {
        addSubview(view)
//      adding auto layout constraint.
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor),
            view.widthAnchor.constraint(equalTo: anchorView.widthAnchor),
            view.heightAnchor.constraint(equalTo: anchorView.heightAnchor),
        ])
    }
}

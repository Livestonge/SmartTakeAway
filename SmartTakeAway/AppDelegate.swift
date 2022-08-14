//
//  AppDelegate.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 22/07/2022.
//

import UIKit
import FirebaseCore

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func setupSubviews(controller: UIViewController, color: UIColor = .orange) -> CloseButton{
    
    let closeButton = CloseButton(crossColor: color)
    controller.view.addSubview(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    let width = closeButton.widthAnchor.constraint(equalToConstant: 20.0)
    let height = closeButton.heightAnchor.constraint(equalToConstant: 20.0)
    let safeArea = controller.view.safeAreaLayoutGuide
    let top = closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20)
    let trailing = closeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
    NSLayoutConstraint.activate([width,height,top,trailing])
    
    return closeButton
}

func animateTransitionWith(customView: UIView, completion: (@escaping(Bool)->Void)){
    
    UIView.transition(with: customView,
                      duration: 0.9,
                      options: .transitionFlipFromTop,
                      animations: {
                        customView.alpha = 0
                        customView.isHidden = true
                        customView.superview?.layoutIfNeeded()
                        },
                      completion: completion)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

extension UIView {
    
    func addSubView(view: UIView, constraintTo anchorView: UIView){
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor),
            view.widthAnchor.constraint(equalTo: anchorView.widthAnchor),
            view.heightAnchor.constraint(equalTo: anchorView.heightAnchor)
        ])
    }
}

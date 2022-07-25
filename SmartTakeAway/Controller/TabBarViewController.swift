//
//  TabBarViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 07/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit
import CoreFoundation

class TabBarViewController: UITabBarController {
    
    
    private lazy var preOrderImage : UIImage = {
           
           let size = CGSize(width: 30, height: 30)
           let image = UIImage(named: "preOrder")!
           let imageToRender = UIGraphicsImageRenderer(size: size).image{ _ in
               image.draw(in: CGRect(origin: .zero, size: size))
           }
           return imageToRender
       }()

    private var foodManager: SelectedFoodProvider?
    private var selectedFood: Food?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = 1
        foodManager = SelectedFoodManager()
        foodManager?.delegate = self
        for controller in viewControllers!{
            if let chosenController = controller as? ChosenMenuViewController{
                chosenController.tabBarItem.image = preOrderImage
            }
        }
    }
  
    func didSelect(_ food: Food){
      self.foodManager?.didSelect(food)
      addBadgeViewAt(position: 3)
    }
    
    func hasSelectedFood() -> Bool{
      self.foodManager?.hasSelectedFood() ?? false
    }

    func addBadgeViewAt(position: Int){
      
        let itemPosition: CGFloat = CGFloat(position)
        let itemWidth:CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)


        let xOffset:CGFloat = 12
        let yOffset:CGFloat = -9

        let badgeView = UILabel()
        badgeView.frame.size = CGSize(width: 17.0, height: 17.0)
        badgeView.center=CGPoint(x:(itemWidth * itemPosition)-(itemWidth/2)+xOffset, y:20+yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        badgeView.clipsToBounds = true
        badgeView.textColor = .orange
        badgeView.text = "●"
        badgeView.textAlignment = .center
        badgeView.font = .systemFont(ofSize: 12.0, weight: .light)
        badgeView.backgroundColor = .orange
        tabBar.addSubview(badgeView)
        badgeView.alpha = 0.0
        badgeView.transform = CGAffineTransform(translationX: 8, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.4,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseIn,
                       animations: {
                        badgeView.alpha = 1.0
                        badgeView.transform = .identity
                       },
                       completion: nil)

    }
    
    private func resetBooking(){
        Orders.shared.ordersList.removeAll()
        let chosenMenuVC = self.viewControllers![2] as? ChosenMenuViewController
        chosenMenuVC!.chosenMenu = nil
        self.selectedIndex = 1
    }
}

extension TabBarViewController: UITabBarControllerDelegate{
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        for view in tabBar.subviews{
            if view is UILabel{
                view.removeFromSuperview()
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is TrackerViewController &&  Orders.shared.ordersList.count == 0 {
            configureAlert(message: "Please,\n Make an order",
                           title: "Empty bucket")
            return false
        } else if  let controller = viewController as? ChosenMenuViewController{
          if hasSelectedFood() == false {
                configureAlert(message: "Please,\n Select a restaurant first.",
                               title: "Select a menu")
                return false
            }
          controller.chosenMenu = selectedFood
        }
        return true
    }
    
    private func configureAlert(message: String, title: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    func showAlert(){
        
        let message = "Your order will be deleted!!!"
        let alert = UIAlertController(title: "Ooops", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Delete", style: .default){ _ in
            self.resetBooking()
        }
        
        let regretAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.addAction(regretAction)
        self.present(alert, animated: true)
    }
    
}

extension TabBarViewController: SelectedFoodDelegate{
  func didReceiveSelected(_ food: Food) {
    self.selectedFood = food
  }
  
  
}

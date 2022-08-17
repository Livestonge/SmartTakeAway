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
    private var restaurantManager: RestaurantManager?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = 1
        foodManager = SelectedFoodManager(selectedFoodObserver: OrderBank.shared)
        foodManager?.delegate = self
        restaurantManager = RestaurantManager(observer: OrderBank.shared)
        restaurantManager?.delegate = self
        for controller in viewControllers!{
          switch controller {
          case let trackerCtrl as TrackerViewController:
            trackerCtrl.orderObserver = OrderBank.shared
          case let navCtrl as UINavigationController:
            guard let ctrl = navCtrl.topViewController as? ViewController else { return }
            ctrl.didCompleteSeletion = self.foodManager?.didCompletedSelecting 
            ctrl.restaurantDetailObserver = OrderBank.shared
          default:
            break
          }
        }
    }
//  MARK: Food selection Methods
  
    func didSelect(restaurant: Restaurant){
      restaurantManager?.didSelectRestaurant(restaurant)
    }
  
    func didSelect(_ food: Food, badgePosition: Int = 3){
        self.foodManager?.didSelect(food)
        addBadgeViewAt(position: badgePosition)
      }
  
    func isOrdersListEmpty() -> Bool {
      self.foodManager?.isOrdersListEmpty() ?? false
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
    
    private func resetBooking(){}
}

// MARK: UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate{
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        for view in tabBar.subviews{
            if view is UILabel{
                view.removeFromSuperview()
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      
        if viewController is TrackerViewController &&  isOrdersListEmpty() == true {
            configureAlert(message: "Please,\n Make an order",
                           title: "Empty bucket")
            return false
        }
        return true
    }
    
    private func configureAlert(message: String, title: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
}
// MARK: SelectedFoodDelegate

extension TabBarViewController: SelectedFoodDelegate{
  
  func didReceiveSelected(_ food: Food) {
    self.selectedFood = food
  }
  
  func didCompleteSelection() {
    addBadgeViewAt(position: 1)
  }
  
  
}


extension TabBarViewController: RestaurantManagerDelegate{
  
  func showMenu() {
    
    guard let navCtrl = viewControllers!.first(where: { type(of: $0) == UINavigationController.self }) as? UINavigationController else {return}
      if let ctrl = navCtrl.topViewController as? ViewController{
        ctrl.didCompleteSeletion = self.foodManager?.didCompletedSelecting
      }
    selectedIndex = 1
    
  }
  
  func showAlertFor(_ restaurant: Restaurant){
    let alert = UIAlertController(title: "Oops",
                                  message: "Your command at the current restaurant will be deleted",
                                  preferredStyle: .alert)
    let deleteAction = UIAlertAction(title: "Continue",
                                     style: .default,
                                     handler: {[weak self] _ in
      self?.restaurantManager?.shouldChange(restaurant)
      
    })
    let defaultAction = UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil)
    alert.addAction(deleteAction)
    alert.addAction(defaultAction)
    self.present(alert,
                 animated: true)
    
  }
  
  func showMessage() {
    let alert = UIAlertController(title: "You have food under preparation",
                                  message: "You can not change restaurant",
                                  preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil)
    
    alert.addAction(defaultAction)
    self.present(alert,
                 animated: true)
  }
  
  
}

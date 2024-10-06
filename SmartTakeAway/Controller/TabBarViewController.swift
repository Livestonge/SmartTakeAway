//
//  TabBarViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 07/04/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: Proprieties

    // A variable for managing the user selected food.
    private var foodManager: SelectedFoodProvider?
    // A variable for the selected food.
    private var selectedFood: Food?
    // A variable for managing the selection of a restaurant.
    private var restaurantManager: RestaurantManager?

    // MARK: ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = 1

        // Dependencies injections
        foodManager = SelectedFoodManager(selectedFoodObserver: OrderBank.shared)
        foodManager?.delegate = self
        restaurantManager = RestaurantManager(observer: OrderBank.shared)
        restaurantManager?.delegate = self

        for controller in viewControllers! {
            switch controller {
            case let trackerCtrl as TrackerViewController:
                trackerCtrl.orderObserver = OrderBank.shared
            case let navCtrl as UINavigationController:
                guard let ctrl = navCtrl.topViewController as? ViewController else { return }
                ctrl.didCompleteSeletion = foodManager?.didCompletedSelecting
                ctrl.restaurantDetailObserver = OrderBank.shared
            default:
                break
            }
        }
    }

    //  MARK: Food selection Methods

    func didSelect(restaurant: Restaurant) {
        // Notifies the manager
        restaurantManager?.didSelectRestaurant(restaurant)
    }

    // Method to check if the user has already selected food.
    func isOrdersListEmpty() -> Bool {
        foodManager?.isOrdersListEmpty() ?? false
    }

    private func addBadgeViewAt(position: Int) {
        let itemPosition = CGFloat(position)
        let itemWidth: CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)

        let xOffset: CGFloat = 12
        let yOffset: CGFloat = -9

        let badgeView = UILabel()
        badgeView.frame.size = CGSize(width: 17.0, height: 17.0)
        badgeView.center = CGPoint(x: (itemWidth * itemPosition) - (itemWidth / 2) + xOffset, y: 20 + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width / 2
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
}

// MARK: UITabBarControllerDelegate Conformance

extension TabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect _: UITabBarItem) {
        // When the user select a tabBar buttom, we remove the orange filled circle.
        for view in tabBar.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }

    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // We display an alert when the user taps on the first tabbar button and the orderList is empty.
        if viewController is TrackerViewController, isOrdersListEmpty() == true {
            configureAlert(message: "Please,\n Make an order",
                           title: "Empty bucket")
            return false
        }
        return true
    }

    // Method used to lauch an alert with the defined parameters.
    private func configureAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

// MARK: SelectedFoodDelegate Conformance

extension TabBarViewController: SelectedFoodDelegate {
    func didReceiveSelected(_ food: Food) {
        // Updates the variable with the received data
        selectedFood = food
    }

    func didCompleteSelection() {
        // When the user complete his food selection, we add an orange filled circle to the first tabbar item.
        addBadgeViewAt(position: 1)
    }
}

// MARK: RestaurantManagerDelegate Conformance

extension TabBarViewController: RestaurantManagerDelegate {
    // This method is called when the user has already selected a restaurant from the map page.
    func showMenu() {
        guard let navCtrl = viewControllers!.first(where: { type(of: $0) == UINavigationController.self }) as? UINavigationController else { return }

        if let ctrl = navCtrl.topViewController as? ViewController {
            // Inject the action to execute when the user complete selection.
            ctrl.didCompleteSeletion = foodManager?.didCompletedSelecting
            ctrl.showMenu()
        }
        selectedIndex = 1
    }

    // This method is called to warn the user that it could loose the already selected items if he change restaurant.
    func showAlertFor(_ restaurant: Restaurant) {
        let alert = UIAlertController(title: "Oops",
                                      message: "Your command at the current restaurant will be deleted",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Continue",
                                         style: .default,
                                         handler: { [weak self] _ in
                                             self?.restaurantManager?.shouldChange(restaurant)

                                         })
        let defaultAction = UIAlertAction(title: "Cancel",
                                          style: .cancel,
                                          handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(defaultAction)
        present(alert,
                animated: true)
    }

    // A method called to inform that some food are in preparation. Changing restaurant is therefore not allowed.
    func showMessage() {
        let alert = UIAlertController(title: "You have food under preparation",
                                      message: "You can not change restaurant",
                                      preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: .cancel,
                                          handler: nil)

        alert.addAction(defaultAction)
        present(alert,
                animated: true)
    }
}

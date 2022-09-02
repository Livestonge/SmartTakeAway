//
//  ViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 13/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Proprieties

    // Variable for holding the list of restaurant to display
    var restaurantList: [Restaurant] = []
    // Variable for the user selected restaurant.
    var selectedRestaurant: Restaurant?
    // An object used to provide a list of restaurant to display
    private var restaurantsProvider: RestaurantsProvider?
    // An object for notifying that a restaurant selection occured.
    var restaurantDetailObserver: RestaurantDetailObservable?
    // An object for managing restaurant selection.
    private var restaurantManager: RestaurantManager?
    // Closure to hold a reference to the action to execute once the user completed his selection.
    var didCompleteSeletion: ((SelectedFood) -> Void)?
    @IBOutlet var tableView: UITableView!

    // MARK: Viewcontroller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        navigationItem.title = "Choose your restaurant"
        tableView.delegate = self
        tableView.dataSource = self
        // Dependencies injections
        restaurantsProvider = RestaurantsProviding()
        restaurantsProvider?.delegate = self
        restaurantsProvider?.getRestaurants()
        restaurantManager = RestaurantManager(observer: restaurantDetailObserver!)
        restaurantManager?.delegate = self
    }
}

// MARK: Tableview Protocol Conformance

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return restaurantList.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Formats the content of the cell.
        let name = restaurantList[indexPath.row].name
        let titleFont = UIFont(name: "ArialRoundedMTBold", size: 22)
        let attributedtext = NSAttributedString(string: name,
                                                attributes: [NSAttributedString.Key.font: titleFont!])

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "customCell")
        cell.textLabel?.attributedText = attributedtext
        let adresse = restaurantList[indexPath.row].adresse
        cell.detailTextLabel?.text = "📍 \(adresse)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurantList[indexPath.row]
        // Notifies the manager about the user's action.
        restaurantManager?.didSelectRestaurant(restaurant)
        // Deselct the row.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: RestaurantsProviderDelegate {
    func didReceive(restaurants: [Restaurant]) {
        // Recieves from the provider a list of restaurants to show.
        restaurantList = restaurants
    }
}

extension ViewController: RestaurantManagerDelegate {
    func showMenu() {
        // Pushs the menu viewController on top of the current viewController if the restaurant manager says so.
        guard let menuCtrl = storyboard?.instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController
        else { return }
        // inject the current closure to the menu viewController.
        menuCtrl.didCompleteSelection = didCompleteSeletion
        navigationController?.pushViewController(menuCtrl,
                                                 animated: true)
    }

    func showAlertFor(_ restaurant: Restaurant) {
        // This alert is shown in the case where there is already a selected restaurant.
        let alert = UIAlertController(title: "Oops",
                                      message: "Your command at the current restaurant will be deleted",
                                      preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Continue",
                                         style: .default,
                                         handler: { [weak self] _ in
                                             // Notifies the manager that the user wants to proceed with the new selection.
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

    func showMessage() {
        // This alert is shown in the case where the user is not allowed to change restaurant.
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

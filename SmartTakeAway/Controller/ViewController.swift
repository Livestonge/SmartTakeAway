//
//  ViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 13/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    var restaurantList: [Restaurant] = []
    var selectedRestaurant: Restaurant?
    private var restaurantsProvider: RestaurantsProvider?
    var restaurantDetailObserver: RestaurantDetailObservable?
    private var restaurantManager: RestaurantManager?
    var didCompleteSeletion: ((SelectedFood) -> Void)?
    @IBOutlet weak var tableView: UITableView!
    
 
  override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        navigationItem.title = "Choose your restaurant"
        tableView.delegate = self
        tableView.dataSource = self
        restaurantsProvider = RestaurantsProviding()
        restaurantsProvider?.delegate = self
        restaurantsProvider?.getRestaurants()
        restaurantManager = RestaurantManager(observer: restaurantDetailObserver!)
        restaurantManager?.delegate = self
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
      self.restaurantManager?.didSelectRestaurant(restaurant)
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension ViewController: RestaurantsProviderDelegate{
  func didReceive(restaurants: [Restaurant]) {
    self.restaurantList = restaurants
  }
  
  
}

extension ViewController: RestaurantManagerDelegate{
  
  func showMenu() {
    guard let menuCtrl = storyboard?.instantiateViewController(withIdentifier: "FoodViewController") as? FoodViewController
    else {return}
    
    menuCtrl.didCompleteSelection = didCompleteSeletion
    self.navigationController?.pushViewController(menuCtrl,
                                                  animated: true)
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

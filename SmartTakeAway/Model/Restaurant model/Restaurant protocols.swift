//
//  Restaurant protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 23/07/2022.
//

import Foundation

protocol RestaurantsProviderDelegate: AnyObject{
  func didReceive(restaurants: [Restaurant])
}

protocol RestaurantsProvider: AnyObject {
  var delegate: RestaurantsProviderDelegate? { get set }
  func getRestaurants()
}

protocol RestaurantDetailObservable{
  func didSelectRestaurant(_ restaurant: Restaurant)
  func getSelectedRestaurant() -> Restaurant?
  func hasOrderedFood() -> Bool
  func deleteOrder()
}

protocol RestaurantManagerDelegate: AnyObject{
  func showMenu()
  func showAlertFor(_ restaurant: Restaurant)
  func showMessage()
}

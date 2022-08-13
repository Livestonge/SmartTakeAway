//
//  RestaurantManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 09/08/2022.
//

import Foundation

class RestaurantManager{
  
  private var restaurantObserver: RestaurantDetailObservable
  weak var delegate: RestaurantManagerDelegate?
  
  init(observer: RestaurantDetailObservable){
    restaurantObserver = observer
  }
  
  func shouldChange(_ restaurant: Restaurant){
    restaurantObserver.deleteOrder()
    restaurantObserver.didSelectRestaurant(restaurant)
    delegate?.showMenu()
  }
  
  func didSelectRestaurant(_ restaurant: Restaurant){
    let currentRestaurant = restaurantObserver.getSelectedRestaurant()
    if currentRestaurant == nil{
      restaurantObserver.didSelectRestaurant(restaurant)
      delegate?.showMenu()
    }else if currentRestaurant!.name != restaurant.name{
      delegate?.showAlertFor(restaurant)
    }
  }
}

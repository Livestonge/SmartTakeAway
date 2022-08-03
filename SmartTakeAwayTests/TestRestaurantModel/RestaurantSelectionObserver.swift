//
//  RestaurantSelectionObserver.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

import Foundation
@testable import SmartTakeAway

class RestaurantSelectionObserver: RestaurantDetailObservable{
  var restaurant: Restaurant?
  
  func didSelectRestaurant(_ restaurant: Restaurant) {
    self.restaurant = restaurant
  }
  
}

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

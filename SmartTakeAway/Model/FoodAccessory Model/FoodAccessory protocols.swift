//
//  FoodAccessory protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 26/07/2022.
//

import Foundation

protocol FoodAccessoryProvider: AnyObject{
  var delegate: FoodAccessoryProviderDelegate? { get set }
  func getFoodAccessories()
}

protocol FoodAccessoryProviderDelegate: AnyObject{
  func didReceiveDrinkList(_ drinks: [String])
  func didReceiveSausList(_ saus: [String])
  func didReceiveTaille(_ taille: [String])
}

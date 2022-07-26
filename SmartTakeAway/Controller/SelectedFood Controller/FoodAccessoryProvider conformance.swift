//
//  FoodAccessoryProvider conformance.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 26/07/2022.
//

import Foundation


extension ChosenMenuViewController: FoodAccessoryProviderDelegate{
  
  func didReceiveDrinkList(_ drinks: [String]) {
    self.drinkList = drinks
  }
  func didReceiveSausList(_ saus: [String]) {
    self.sausList = saus
  }
  
  
}

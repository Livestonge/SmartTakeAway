//
//  FoodAccessoryProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 26/07/2022.
//

import Foundation

class FoodAccessoryProviding: FoodAccessoryProvider {
  
  private var foodAccessoryList: [String: [String]]
  weak var delegate: FoodAccessoryProviderDelegate?
  
  init(){
    self.foodAccessoryList = StoredData(fileName: "DAndSData").model ?? [:]
  }
  
  private func getDrinkList() {
    let drinks = self.foodAccessoryList["Drink"] ?? []
    delegate?.didReceiveDrinkList(drinks)
  }
  
  private func getSausList() {
    let saus = self.foodAccessoryList["Sauce"] ?? []
    delegate?.didReceiveSausList(saus)
  }
  
  func getFoodAccessories() {
    getDrinkList()
    getSausList()
  }
  
  
}

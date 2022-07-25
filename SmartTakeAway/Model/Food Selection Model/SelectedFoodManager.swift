//
//  SelectedFoodManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 25/07/2022.
//

import Foundation

class SelectedFoodManager: SelectedFoodProvider {
  
  private var selectedFood: Food?
  weak var delegate: SelectedFoodDelegate?
  
  func didSelect(_ food: Food){
    self.selectedFood = food
    delegate?.didReceiveSelected(food)
  }
  
  func hasSelectedFood() -> Bool{
    selectedFood != nil
  }
}

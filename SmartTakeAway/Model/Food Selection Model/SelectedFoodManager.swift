//
//  SelectedFoodManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 25/07/2022.
//

import Foundation

class SelectedFoodManager: SelectedFoodProvider {
  
  private var selectedFood: Food?{
    didSet{
      if didCompleteSelection() && selectedFood != nil {
        Orders.shared.ordersList.append(selectedFood!)
      }
    }
  }
  weak var delegate: SelectedFoodDelegate?
  
  func didSelect(_ food: Food){
    self.selectedFood = food
    delegate?.didReceiveSelected(food)
  }
  
  func hasSelectedFood() -> Bool{
    selectedFood != nil
  }
  
  func didCompleteSelection() -> Bool{
    selectedFood?.drink != nil &&
    selectedFood?.sauce_1 != nil &&
    selectedFood?.sauce_2 != nil
  }
}

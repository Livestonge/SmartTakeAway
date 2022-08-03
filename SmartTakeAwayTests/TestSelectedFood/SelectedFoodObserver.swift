//
//  SelectedFoodObserver.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

import Foundation
@testable import SmartTakeAway

class SelectedFoodObserver: SelectedFoodObservable{
  var food: Food?
  
  func didCompletedSelecting(_ food: Food) {
    self.food = food
  }
  
  func isFoodListEmpty() -> Bool {
    food != nil
  }
  
  
}

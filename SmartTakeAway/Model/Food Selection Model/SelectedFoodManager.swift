//
//  SelectedFoodManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 25/07/2022.
//

import Foundation


protocol SelectedFoodObservable{
  func didCompletedSelecting(_ food: Food)
  func isFoodListEmpty() -> Bool
}

class SelectedFoodManager: SelectedFoodProvider {
  
  var selectedFoodObserver: SelectedFoodObservable
  weak var delegate: SelectedFoodDelegate?
  
  init(selectedFoodObserver: SelectedFoodObservable){
    self.selectedFoodObserver = selectedFoodObserver
  }
  
  func didSelect(_ food: Food){
    delegate?.didReceiveSelected(food)
  }
  
  func didCompletedSelecting(_ food: Food) {
    self.selectedFoodObserver.didCompletedSelecting(food)
    self.delegate?.didCompleteSelection()
  }
  
  func isOrdersListEmpty() -> Bool {
    self.selectedFoodObserver.isFoodListEmpty()
  }
}

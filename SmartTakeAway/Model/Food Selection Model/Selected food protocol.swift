//
//  Selected food protocol.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 25/07/2022.
//

import Foundation

protocol SelectedFoodProvider: AnyObject {
  var delegate: SelectedFoodDelegate? { get set }
  func didSelect(_ food: Food)
  func didCompletedSelecting(_ food: SelectedFood)
  func isOrdersListEmpty() -> Bool
}
protocol SelectedFoodDelegate: AnyObject {
  func didReceiveSelected(_ food: Food)
  func didCompleteSelection()
}

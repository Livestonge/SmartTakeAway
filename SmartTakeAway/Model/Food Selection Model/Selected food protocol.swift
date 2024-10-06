//
//  Selected food protocol.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 25/07/2022.
//

import Foundation

// Protocol used to group the requirements for an object providing and managing a selected food.
protocol SelectedFoodProvider: AnyObject {
    var delegate: SelectedFoodDelegate? { get set }
    func didCompletedSelecting(_ food: SelectedFood)
    func isOrdersListEmpty() -> Bool
}

// Protocol used to group the requirements for an object which communicates with an SelectedFoodProvider
protocol SelectedFoodDelegate: AnyObject {
    func didReceiveSelected(_ food: Food)
    func didCompleteSelection()
}

// Protocol used to group the requirements for an object which stores the user order.
protocol SelectedFoodObservable {
    func didCompletedSelecting(_ food: SelectedFood)
    func isFoodListEmpty() -> Bool
}

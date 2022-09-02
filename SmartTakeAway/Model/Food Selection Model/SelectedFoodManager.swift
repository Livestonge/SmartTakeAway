//
//  SelectedFoodManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 25/07/2022.
//

import Foundation

class SelectedFoodManager: SelectedFoodProvider {
    // Object wich holds the user's order.
    var selectedFoodObserver: SelectedFoodObservable
    weak var delegate: SelectedFoodDelegate?

    init(selectedFoodObserver: SelectedFoodObservable) {
        self.selectedFoodObserver = selectedFoodObserver
    }

    func didCompletedSelecting(_ food: SelectedFood) {
        selectedFoodObserver.didCompletedSelecting(food)
        delegate?.didCompleteSelection()
    }

    func isOrdersListEmpty() -> Bool {
        selectedFoodObserver.isFoodListEmpty()
    }
}

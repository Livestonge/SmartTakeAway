//
//  SelectedFoodObserver.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

import Foundation
@testable import SmartTakeAway

class SelectedFoodObserver: SelectedFoodObservable {
    var food: OrderedFood?

    func isFoodListEmpty() -> Bool {
        food != nil
    }

    func didCompletedSelecting(_ selectedFood: SelectedFood) {
        food = OrderedFood(name: selectedFood.name,
                           price: selectedFood.price ?? 0,
                           drink: selectedFood.food.drink ?? "",
                           sauces: [selectedFood.food.sauce_1 ?? "", selectedFood.food.sauce_2 ?? ""].joined(separator: ", "))
    }
}

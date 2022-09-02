//
//  FirebaseInterface.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 22/08/2022.
//

import FirebaseAnalytics
import Foundation

class FirebaseManager {
    func didSelectRestaurant(_ restaurant: Restaurant) {
        Analytics.logEvent("restautaut_selection",
                           parameters: [
                               "restaurant_name": restaurant.name,
                           ])
    }

    func didSelectFood(_ food: SelectedFood?) {
        guard let food = food else { return }
        Analytics.logEvent("Selected_food_controller",
                           parameters: [
                               "selected_food": food.name,
                               "selected_food_type": food.type,
                           ])
    }

    func didOrder(_ order: Order?) {
        guard let order = order else { return }
        Analytics.logEvent("order_selection_confirmed",
                           parameters: [
                               "selected_order_count": order.foodsList.count,
                               "selected_drink_names": order.foodsList.map(\.drink).reduce("") { $0 + ", " + $1 },
                               "selected_sauces_names": order.foodsList.map(\.sauces).reduce("") { $0 + ", " + $1 },
                               "selected_food_names": order.foodsList.map(\.name).reduce("") { $0 + ", " + $1 },
                               "selected_food_restaurant_name": order.restaurantName as Any,
                           ])
    }
}

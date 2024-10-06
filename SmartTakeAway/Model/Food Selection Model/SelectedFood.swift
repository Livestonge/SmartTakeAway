//
//  FoodToDisplay.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 11/08/2022.
//

import Foundation

// Object used to hold the details of a user's selected food.
struct SelectedFood {
    let type: String
    var food: Food
    var price: Double?

    init(type: String, food: Food, price _: Double? = nil) {
        self.type = type
        self.food = food
        updatePriceWith()
    }

    var name: String {
        food.name
    }

    var description: String {
        food.description
    }

    var imagePath: String {
        food.image ?? ""
    }

    // Method used to update the price propriety for the case of a pizza.
    mutating func updatePriceWith(_ size: Int? = nil) {
        switch food.price {
        case let .sandwich(amount):
            price = amount
        case let .pizza(medium: mediumPrice, grande: grandePrice, large: largePrice):
            switch size {
            case 2:
                price = largePrice
            case 1:
                price = grandePrice
            default:
                price = mediumPrice
            }
        }
    }

    mutating func updateAcessories(userSelection: UserSelection) {
        food.drink = userSelection.drink?.name
        food.sauce_1 = userSelection.sauces.0?.name
        food.sauce_2 = userSelection.sauces.1?.name
    }
}

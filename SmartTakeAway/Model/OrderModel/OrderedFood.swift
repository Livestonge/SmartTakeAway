//
//  OrderedFood.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 11/08/2022.
//

import Foundation

// An object to keep track of the details of a selected food.
struct OrderedFood {
    let name: String
    let price: Double
    let drink: String
    let sauces: String
    var status: OrderStatus = .toBeConfirmed
}

// Differents phases of the preparation of a food.
enum OrderStatus {
    case preparation, finished, toBeConfirmed
}

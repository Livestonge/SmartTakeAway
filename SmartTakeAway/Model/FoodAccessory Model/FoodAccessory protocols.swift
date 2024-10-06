//
//  FoodAccessory protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 26/07/2022.
//

import Foundation
// Protocol used to group the requirements for an object providing the accessories related to a food.
protocol FoodAccessoryProvider: AnyObject {
    var delegate: FoodAccessoryProviderDelegate? { get set }
    func getFoodAccessories()
}

// Protocol used to group the requirements for an object which communicates with an FoodAccessoryProvider
protocol FoodAccessoryProviderDelegate: AnyObject {
    func didReceiveDrinkList(_ drinks: [String])
    func didReceiveSausList(_ saus: [String])
    func didReceiveTaille(_ taille: [String])
}

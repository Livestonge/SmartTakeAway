//
//  FoodAccessoryProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 26/07/2022.
//

import Foundation

class FoodAccessoryProviding: FoodAccessoryProvider {
    // Propriety for the different types of accessories
    private var foodAccessoryList: [String: [String]]
    weak var delegate: FoodAccessoryProviderDelegate?
    // Propriety used to determine which accessories to send to the delegate.
    private var foodType: String

    init(foodType: String) {
        self.foodType = foodType
        // Load the saved accessories.
        foodAccessoryList = StoredData(fileName: "DAndSData").model ?? [:]
    }

    private func getDrinkList() {
        let drinks = foodAccessoryList["Drink"] ?? []
        delegate?.didReceiveDrinkList(drinks)
    }

    private func getSausList() {
        let saus = foodAccessoryList["Sauce"] ?? []
        delegate?.didReceiveSausList(saus)
    }

    private func getTailleList() {
        let tailleList = foodAccessoryList["Taille"] ?? []
        delegate?.didReceiveTaille(tailleList)
    }

    // Method used to ask for the accessories related to a food.
    func getFoodAccessories() {
        switch foodType {
        case "Pizza":
            getDrinkList()
            getSausList()
            getTailleList()
        default:
            getDrinkList()
            getSausList()
        }
    }
}

//
//  NewManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 07/08/2022.
//

import Foundation

// Type use to represent an accessory to a food f.ex a drink or a sauce.
struct Accessory {
    let id: Int
    // Variable used to distinguish between a sauce, a drink or a size.
    let type: String
    let name: String
}

// Type used to group the user selected accessories.
struct UserSelection {
    var drink: Accessory? = nil
    var size: Accessory? = nil
    // The user is allowed to include 2 sauces.
    var sauces: (Accessory?, Accessory?) = (nil, nil)
}

// Protocol used to group the requirements for objects which communicates with a FoodSelection object.
protocol AccessoriesManagerDelegate: AnyObject {
    func didReceive(selection: UserSelection)
}

// An object which handles the user's selection of accessories.
class FoodSelectionManager {
    // The current userSelection.
    var userSelection: UserSelection
    // Propriety used to communicate with objects which conform to AccessoriesManagerDelegate.
    weak var delegate: AccessoriesManagerDelegate?

    init() {
        // Instantiate a default instant for the userSelection propriety.
        userSelection = UserSelection()
    }

    // Method used to update the current userSelection propriety.
    func didSelect(_ accessory: Accessory) {
        switch accessory.type {
        case "Drink":
            userSelection.drink = accessory
        case "Taille":
            userSelection.size = accessory
        case "Sauce":
            switch userSelection.sauces {
            case (nil, nil):
                userSelection.sauces = (accessory, nil)
            /*
               If the user has already choosen a sauce, it returns nil if the new selection is the same as the current sauce
              otherwise it stores the new sauce in the userSelection propriety.
             */
            case (let currentSauce?, nil):
                userSelection.sauces.1 = currentSauce.id == accessory.id ? nil : accessory
            case (nil, let currentSauce?):
                userSelection.sauces.0 = currentSauce.id == accessory.id ? nil : accessory
            case (_?, _?):
                // It nullifies if the user reSelect the same sauce, otherwise it updates the second value in the tuple.
                if userSelection.sauces.0?.id == accessory.id {
                    userSelection.sauces.0 = nil
                } else if userSelection.sauces.1?.id == accessory.id {
                    userSelection.sauces.1 = nil
                } else {
                    userSelection.sauces.1 = accessory
                }
            }
        default: break
        }
        // Notifies the delegate with the updated userSelection propriety.
        delegate?.didReceive(selection: userSelection)
    }
}

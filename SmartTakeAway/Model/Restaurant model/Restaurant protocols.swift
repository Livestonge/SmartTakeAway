//
//  Restaurant protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 23/07/2022.
//

import Foundation

// Protocol used to group the requirements for an object providing the list of restaurants.
protocol RestaurantsProvider: AnyObject {
    var delegate: RestaurantsProviderDelegate? { get set }
    func getRestaurants()
}

// Protocol used to group the requirements for an object which communicates with an MenuProvider.
protocol RestaurantsProviderDelegate: AnyObject {
    func didReceive(restaurants: [Restaurant])
}

// Protocol used to group the requirements for an object which stores the details of the user's order.
protocol RestaurantDetailObservable {
    func didSelectRestaurant(_ restaurant: Restaurant)
    func getSelectedRestaurant() -> Restaurant?
    func hasFoodInPreparation() -> Bool
    func deleteOrder()
}

// Protocol used to group the requirements for an object which communicates with an RestaurantManager instance.
protocol RestaurantManagerDelegate: AnyObject {
    func showMenu()
    func showAlertFor(_ restaurant: Restaurant)
    func showMessage()
}

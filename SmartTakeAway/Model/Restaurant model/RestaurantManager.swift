//
//  RestaurantManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 09/08/2022.
//

import Foundation

class RestaurantManager {
    // Object used to notify for user's selection related to restaurant.
    private var restaurantObserver: RestaurantDetailObservable
    // Propriety used to communicate with a viewController.
    weak var delegate: RestaurantManagerDelegate?

    init(observer: RestaurantDetailObservable) {
        restaurantObserver = observer
    }

    // Method called when the user want to proceed with changing his current restaurant.
    func shouldChange(_ restaurant: Restaurant) {
        restaurantObserver.deleteOrder()
        restaurantObserver.didSelectRestaurant(restaurant)
        delegate?.showMenu()
    }

    func didSelectRestaurant(_ restaurant: Restaurant) {
        let currentRestaurant = restaurantObserver.getSelectedRestaurant()
        // we store or restore the selected restaurant.
        if currentRestaurant == nil || currentRestaurant?.name == restaurant.name {
            restaurantObserver.didSelectRestaurant(restaurant)
            delegate?.showMenu()
        } else if currentRestaurant!.name != restaurant.name, !restaurantObserver.hasFoodInPreparation() {
            // An alert is displayed to inform the user that the selected food will be deleted by selecting a new restaurant.
            delegate?.showAlertFor(restaurant)
            // The user is not allowed to change restaurant if food is in preparation.
        } else if currentRestaurant!.name != restaurant.name, restaurantObserver.hasFoodInPreparation() {
            delegate?.showMessage()
        }
    }
}

//
//  RestaurantsProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 23/07/2022.
//

import Foundation

class RestaurantsProviding: RestaurantsProvider {
    weak var delegate: RestaurantsProviderDelegate?

    func getRestaurants() {
        // we fetch the restaurants
        let restaurants = StoredData<[Restaurant]>(fileName: "Restaurants")
        // we call the delegate to hand him the restaurants.
        delegate?.didReceive(restaurants: restaurants.model ?? [])
    }
}

//
//  Order protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 27/07/2022.
//

import Foundation
// Protocol used to group the requirements for an object providing the user order.
protocol OrderProvider {
    var delegate: OrderProviderDelegate? { get set }
    func willShowOrderPage()
    func orderPageWillDisappear()
    func getTheListOfFood()
    func delete(_ food: OrderedFood)
    func deleteOrder()
    func didValidateOrder()
}

// Protocol used to group the requirements for an object which stores the user order.
protocol OrderObservable {
    func getMadeOrder() -> Order?
    func delete(_ food: OrderedFood)
    func deleteOrder()
    func didValidateOrder()
}

// Protocol used to group the requirements for an object which communicates with an OrderProvider.
protocol OrderProviderDelegate: AnyObject {
    func didReceiveFood(_ list: [OrderedFood], withStatus: OrderStatus)
    func didReceiveRestaurant(_ restaurant: Restaurant)
    func showAlertWith(message: String)
}

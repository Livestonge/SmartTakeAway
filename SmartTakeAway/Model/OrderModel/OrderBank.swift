//
//  OrderBank.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 01/08/2022.
//

import Foundation

// An object Used to hold the order of a user.
class OrderBank {
    // MARK: Proprieties

    private var currentOrder: Order?
    // Using a singleton to store all the related details of an order in one place.
    static var shared = OrderBank()
    // Object for tracking some events related to the current order.
    lazy var analyticsManager = FirebaseManager()

    private init() {}
}

// MARK: RestaurantDetailObservable Protocol Conformance

extension OrderBank: RestaurantDetailObservable {
    func getSelectedRestaurant() -> Restaurant? {
        guard let order = currentOrder else { return nil }
        return Restaurant(name: order.restaurantName!,
                          adresse: order.restaurantAdress!)
    }

    // When the user chooses a restaurant. We instantiate an order with the selected restaurant.
    func didSelectRestaurant(_ restaurant: Restaurant) {
        currentOrder = Order(foodsList: [],
                             restaurantName: restaurant.name,
                             restaurantAdress: restaurant.adresse)
    }

    func hasFoodInPreparation() -> Bool {
        currentOrder?.foodsList.first(where: { $0.status == .preparation }) != nil
    }
}

// MARK: SelectedFoodObservable Protocol Conformance

extension OrderBank: SelectedFoodObservable {
    typealias Status = OrderStatus

    func didCompletedSelecting(_ food: SelectedFood) {
        let sauce_0 = food.food.sauce_1 ?? "none"
        let sauce_1 = food.food.sauce_2 ?? "none"

        // Join the 2 values.
        let sauces = sauce_0 + ", " + sauce_1
        let orderedFood = OrderedFood(name: food.name,
                                      price: food.price ?? 0,
                                      drink: food.food.drink ?? "none",
                                      sauces: sauces)
        currentOrder?.foodsList.append(orderedFood)
    }

    // Method used to start the preparation of validated food items.
    func didValidateOrder() {
        analyticsManager.didOrder(currentOrder)
        // Retrieves from the current order the food items to prepare.
        let foodlList = currentOrder?
            .foodsList
            .map { food -> OrderedFood in
                var toUpdatefood = food
                let currentStatus = toUpdatefood.status
                let canBePrepared = ![Status.preparation, Status.finished].contains(currentStatus)
                // It sets to prepare if the item is not already in preparation.
                toUpdatefood.status = canBePrepared ? .preparation : currentStatus
                return toUpdatefood
            }
        // Updates the list.
        currentOrder?.foodsList = foodlList ?? []
        startPreparation()
    }

    // Method used to simulate a food preparation.
    private func startPreparation() {
        var foodsList = currentOrder?.foodsList.filter { $0.status == .preparation } ?? []
        let initialCount = foodsList.count
        // Loop to run until the list of food to prepare is empty is empty.
        while foodsList.count > 0 {
            // The duration of a singel preparation
            let timeToWait = initialCount - foodsList.count + 8
            // Value captured by the Timer.
            let lastFoodItem = foodsList.removeLast()
            // Timer to simulate the preparation and then updates the current order.
            Timer.scheduledTimer(withTimeInterval: TimeInterval(timeToWait),
                                 repeats: false) { [lastFoodItem, weak self] _ in
                var toUpdateFood = lastFoodItem
                toUpdateFood.status = .finished

                let list = self?.currentOrder?
                    .foodsList
                    .map { food -> OrderedFood in
                        if toUpdateFood.name == food.name {
                            return toUpdateFood
                        }
                        return food
                    }

                self?.currentOrder?.foodsList = list ?? []
            }
        }
    }

    func isFoodListEmpty() -> Bool {
        currentOrder?.foodsList.isEmpty ?? true
    }
}

// MARK: OrderObservable Protocol Conformance

extension OrderBank: OrderObservable {
    func getMadeOrder() -> Order? {
        currentOrder
    }

    func delete(_ food: OrderedFood) {
        guard let index = currentOrder?.foodsList.firstIndex(where: { $0.name == food.name }) else { return }
        currentOrder?.foodsList.remove(at: index)
    }

    func deleteOrder() {
        currentOrder = nil
    }
}

//
//  OrderBank.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 01/08/2022.
//

import Foundation

class OrderBank {
  
  private var currentOrder: Order?
  static var shared = OrderBank()
  
  private init(){}
}

extension OrderBank: RestaurantDetailObservable{
  func getSelectedRestaurant() -> Restaurant?{
    guard let order = currentOrder else {return nil}
    return Restaurant(name: order.restaurantName!,
                      adresse: order.restaurantAdress!)
  }
  
  func didSelectRestaurant(_ restaurant: Restaurant){
    self.currentOrder = Order(foodsList: [],
                              restaurantName: restaurant.name,
                              restaurantAdress: restaurant.adresse)
  }
  
}

extension OrderBank: SelectedFoodObservable{
  
  func didCompletedSelecting(_ food: SelectedFood){
    
    let sauce_0 = food.food.sauce_1 ?? "none"
    let sauce_1 = food.food.sauce_2 ?? "none"
    
    let sauces = sauce_0 + ", " + sauce_1
    let orderedFood = OrderedFood(name: food.name,
                                  price: food.price ?? 0,
                                  drink: food.food.drink ?? "none",
                                  sauces: sauces)
    currentOrder?.foodsList.append(orderedFood)
  }
  
  func isFoodListEmpty() -> Bool {
    currentOrder?.foodsList.isEmpty ?? true
  }
}

extension OrderBank: OrderObservable{
  
  func getMadeOrder() -> Order?{
    self.currentOrder
  }
  
  func deleteFoodAt(_ index: Int) {
    currentOrder?.foodsList.remove(at: index)
  }
  
  func deleteOrder(){
    currentOrder = nil
  }
}


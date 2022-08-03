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
  
  func didSelectRestaurant(_ restaurant: Restaurant){
    self.currentOrder = Order(foodsList: [],
                              restaurantName: restaurant.name,
                              restaurantAdress: restaurant.adresse)
  }
  
}

extension OrderBank: SelectedFoodObservable{
  
  func didCompletedSelecting(_ food: Food){
    currentOrder?.foodsList.append(food)
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


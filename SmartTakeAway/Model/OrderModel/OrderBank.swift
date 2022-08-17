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
  lazy var analyticsManager = FirebaseManager()
  
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
  
  func hasOrderedFood() -> Bool {
    currentOrder?.foodsList.first(where: { $0.status == .preparation}) != nil
  }
  
}

extension OrderBank: SelectedFoodObservable{
  
  typealias Status = OrderStatus
  
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
  
  func didValidateOrder(){
    analyticsManager.didOrder(currentOrder)
    
    let foodlList = currentOrder?
                                .foodsList
                                .map{ food -> OrderedFood in
                                      var toUpdatefood = food
                                      let currentStatus = toUpdatefood.status
                                      let canBePrepared = ![Status.preparation, Status.finished].contains(currentStatus)
                                      toUpdatefood.status = canBePrepared ? .preparation : currentStatus
                                      return toUpdatefood
                                    }
    currentOrder?.foodsList = foodlList ?? []
    startPreparation()
  }
  
  private func startPreparation(){
    
    var foodsList = self.currentOrder?.foodsList.filter({ $0.status == .preparation}) ?? []
    let initialCount = foodsList.count
    
    while foodsList.count > 0{
      let timeToWait = initialCount - foodsList.count + 3
      let lastFoodItem = foodsList.removeLast()
      Timer.scheduledTimer(withTimeInterval: TimeInterval(5 + timeToWait),
                           repeats: false){ [lastFoodItem, weak self] _ in
        var toUpdateFood = lastFoodItem
        toUpdateFood.status = .finished
        
        let list = self?.currentOrder?
                        .foodsList
                        .map{ food -> OrderedFood in
                              if toUpdateFood.name == food.name{
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

extension OrderBank: OrderObservable{
  
  func getMadeOrder() -> Order?{
    self.currentOrder
  }
  
  func delete(_ food: OrderedFood) {
    guard let index = currentOrder?.foodsList.firstIndex(where: { $0.name == food.name }) else { return }
    currentOrder?.foodsList.remove(at: index)
  }
  
  func deleteOrder(){
    currentOrder = nil
  }
}


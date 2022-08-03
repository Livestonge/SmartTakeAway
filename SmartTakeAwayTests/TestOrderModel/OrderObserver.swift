//
//  OrderObserver.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

import Foundation
@testable import SmartTakeAway

class OrderObserver: OrderObservable {
  
  var order: Order?
  
  init(){
    let restaurant = Restaurant(name: "City burger",
                                adresse: "01 avenue de Saint Jacque 75034 Paris")
    
    let food_1 = Food(name: "O tacos simple",
                    price: Price.sandwich(8),
                    description: "merguez avec sauce fromagère",
                    image: nil)
    
    let food_2 = Food(name: "Kebab assiette",
                    price: Price.sandwich(12),
                    description: "avec frites, tomates et onion",
                    image: nil)
    self.order = Order(foodsList: [food_1, food_2],
                       restaurantName: restaurant.name,
                       restaurantAdress: restaurant.adresse)
  }
  
  func getMadeOrder() -> Order? {
    self.order
  }
  
  func deleteFoodAt(_ index: Int) {
    self.order?.foodsList.remove(at: index)
  }
  
  func deleteOrder() {
    self.order = nil
  }
}

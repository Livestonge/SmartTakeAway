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
    
    
   let orderedFood_1 = OrderedFood(name: food_1.name,
                             price: food_1.priceAmount,
                             drink: food_1.drink ?? "",
                             sauces: [food_1.sauce_1 ?? "",  food_1.sauce_2 ?? ""].joined(separator: ", "))
    let orderedFood_2 = OrderedFood(name: food_2.name,
                                    price: food_2.priceAmount,
                                    drink: food_2.drink ?? "",
                                    sauces: [food_2.sauce_1 ?? "", food_2.sauce_2 ?? ""].joined(separator: ", "))
    
    self.order = Order(foodsList: [orderedFood_1, orderedFood_2],
                       restaurantName: restaurant.name,
                       restaurantAdress: restaurant.adresse)
  }
  
  func getMadeOrder() -> Order? {
    self.order
  }
  
  func delete(_ food: OrderedFood) {
    guard let index = self.order?.foodsList.firstIndex(where: { $0.name == food.name }) else { return }
    self.order?.foodsList.remove(at: index)
  }
  
  func deleteOrder() {
    self.order = nil
  }
  
  func didValidateOrder() {
    let list = self.order?.foodsList.map{ food -> OrderedFood in
                                          var toUpdate = food
                                          toUpdate.status = .preparation
                                          return toUpdate
                                        }
    self.order?.foodsList = list ?? []
  }
}

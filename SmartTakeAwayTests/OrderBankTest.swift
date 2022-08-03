//
//  OrderBankTest.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

import XCTest
@testable import SmartTakeAway

class OrderBankTest: XCTestCase {

  var sut: OrderBank?
  
  override func setUp() {
    super.setUp()
    sut = OrderBank.shared
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testInsertRestaurant(){
    let restaurant = Restaurant(name: "City burger",
                                adresse: "01 avenue de Saint Jacque 75034 Paris")
    
    sut?.didSelectRestaurant(restaurant)
    
    let order = sut?.getMadeOrder()
    XCTAssertNotNil(order)
    XCTAssertEqual(order?.restaurantName, "City burger")
  }
  
  func instantiateAnOrderBankWithRestaurant() -> OrderBank{
    let bank = OrderBank.shared
    let restaurant = Restaurant(name: "City burger",
                                adresse: "01 avenue de Saint Jacque 75034 Paris")
    
    bank.didSelectRestaurant(restaurant)
    return bank
  }
  
  func testDidSelectFood(){
    
    sut = instantiateAnOrderBankWithRestaurant()
    
    var food = Food(name: "O tacos simple",
                    price: Price.sandwich(8),
                    description: "merguez avec sauce fromagère",
                    image: nil)
    
    food.drink = "Pepsi"
    food.sauce_1 = "Algerienne"
    food.sauce_2 = "Harissa"
    
    sut?.didCompletedSelecting(food)
    let order = sut?.getMadeOrder()
    let storedFood = order?.foodsList.first
    
    XCTAssertNotNil(order)
    XCTAssertNotNil(storedFood)
    XCTAssertEqual(storedFood?.name, "O tacos simple")
    XCTAssertEqual(storedFood?.description, "merguez avec sauce fromagère")
    XCTAssertEqual(storedFood?.priceAmount, 8)
  }
  
  func testDeletingOrder(){
    
    sut = instantiateAnOrderBankWithRestaurant()
    var food_1 = Food(name: "O tacos simple",
                    price: Price.sandwich(8),
                    description: "merguez avec sauce fromagère",
                    image: nil)
    
    food_1.drink = "Pepsi"
    food_1.sauce_1 = "Algerienne"
    food_1.sauce_2 = "Harissa"
    sut?.didCompletedSelecting(food_1)
    
    var food_2 = Food(name: "Kebab assiette",
                    price: Price.sandwich(12),
                    description: "avec frites, tomates et onion",
                    image: nil)
    
    food_2.drink = "Ice tea"
    food_2.sauce_1 = "Algerienne"
    food_2.sauce_2 = "Harissa"
    
    sut?.didCompletedSelecting(food_2)
    sut?.deleteFoodAt(1)
    XCTAssertEqual(sut?.getMadeOrder()?.foodsList.count, 1)
    XCTAssertEqual(sut?.getMadeOrder()?.foodsList.contains{ $0.name == "Kebab assiette" }, false)
    sut?.deleteOrder()
    XCTAssertNil(sut?.getMadeOrder())
  }

}

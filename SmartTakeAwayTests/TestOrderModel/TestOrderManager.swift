//
//  TestOrderManager.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

import XCTest
@testable import SmartTakeAway

class TestOrderManager: XCTestCase {

  var sut: OrderManager?
  var order: Order?
  var observer: OrderObserver?
  
  override func setUp() {
    super.setUp()
    observer = OrderObserver()
    sut = OrderManager(orderObserver: observer!)
    sut?.delegate = self
  }
  
  override func tearDown() {
    sut = nil
    observer = nil
    order = nil
    super.tearDown()
  }

  func testGetOrder(){
    sut?.getMadeOrder()
    XCTAssertNotNil(self.order)
    XCTAssertEqual(self.order?.foodsList.first?.name, "O tacos simple")
  }
  
  func testUpdateDelegate(){
    let restaurant = Restaurant(name: "City burger",
                                adresse: "01 avenue de Saint Jacque 75034 Paris")
    let order = Order(foodsList: [],
                      restaurantName: restaurant.name,
                      restaurantAdress: restaurant.adresse)
    
    sut?.updateDelegateWith(order)
    XCTAssertNotNil(self.order)
    XCTAssertTrue(self.order!.foodsList.isEmpty)
    XCTAssertEqual(self.order?.restaurantName, "City burger")
  }
  
  func testDeleteFoodAt(){
    sut?.getMadeOrder()
    let count = self.order?.foodsList.count
    sut?.deleteFoodAt(count! - 1)
    sut?.getMadeOrder()
    XCTAssertLessThan(self.order!.foodsList.count, count!)
    XCTAssertEqual(self.order?.foodsList.count, count! - 1)
  }
  
  func testDeleteOrder(){
    sut?.getMadeOrder()
    XCTAssertNotNil(self.order)
    sut?.deleteOrder()
    sut?.getMadeOrder()
    XCTAssertNil(self.order)
  }
}

extension TestOrderManager: OrderProviderDelegate{
  
  func didReceiveOrder(_ order: Order?) {
    self.order = order
  }
}

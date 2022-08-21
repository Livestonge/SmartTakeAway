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
  var foodList: [OrderedFood]?
  
  override func setUp() {
    super.setUp()
    observer = OrderObserver()
    sut = OrderManager(orderObserver: observer!)
    sut?.delegate = self
    foodList = []
  }
  
  override func tearDown() {
    sut = nil
    observer = nil
    order = nil
    foodList = nil
    super.tearDown()
  }

  func testGetOrder(){
    sut?.getMadeOrder()
    XCTAssertNotNil(self.foodList)
    XCTAssertFalse(self.foodList!.isEmpty)
  }
  
  func testOrderInitialStatus(){
    sut?.getMadeOrder()
    XCTAssertNotNil(self.foodList)
    XCTAssertTrue(self.foodList!.allSatisfy({ $0.status == .toBeConfirmed }))
  }
  
  func testDidValidate(){
    sut?.getMadeOrder()
    XCTAssertNotNil(self.foodList)
    XCTAssertTrue(self.foodList!.allSatisfy({ $0.status == .toBeConfirmed }))
    self.foodList = []
    sut?.didValidateOrder()
    XCTAssertFalse(self.foodList!.isEmpty)
    XCTAssertTrue(self.foodList!.allSatisfy({ $0.status == .preparation }))
  }
  
  func testDeleteFood(){
    sut?.getMadeOrder()
    let count = foodList?.count ?? 0
    XCTAssertNotNil(foodList)
    XCTAssertFalse(foodList!.isEmpty)
    XCTAssertEqual(foodList!.count, count)
    let food = foodList!.first!
    self.foodList = []
    sut?.delete(food)
    sut?.getMadeOrder()
    XCTAssertFalse(foodList!.isEmpty)
    XCTAssertFalse(foodList!.contains(where: { $0.name == food.name }))
  }
  
  func testDeleteOrder(){
    self.order = self.observer?.getMadeOrder()
    XCTAssertNotNil(self.order)
    sut?.deleteOrder()
    self.order = self.observer?.getMadeOrder()
    XCTAssertNil(self.order)
  }
}

extension TestOrderManager: OrderProviderDelegate{
  func didReceiveFood(_ list: [OrderedFood], withStatus: OrderStatus) {
    self.foodList?.append(contentsOf: list)
    
  }
  
  func didReceiveRestaurant(_ restaurant: Restaurant) {
    //
  }
  
  func showAlertWith(message: String) {
    //
  }
  
  
  func didReceiveOrder(_ order: Order?) {
    self.order = order
  }
}

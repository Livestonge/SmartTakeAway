//
//  TestMenuProvider.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

import XCTest
@testable import SmartTakeAway

class TestMenuProvider: XCTestCase {
  
  var sut: MenuProviding?
  var foodList: [Food]? = []
  var foodTypes: [String]? = []
  
  override func setUp() {
    super.setUp()
    sut = MenuProviding()
    sut?.delegate = self
    
  }
  
  override func tearDown() {
    sut = nil
    foodList = nil
    foodTypes = nil
    super.tearDown()
  }
  
  func testGetSandwichMenu(){
    sut?.getMenuFor(.sandwiches)
    XCTAssertNotNil(self.foodList)
    XCTAssertEqual(self.foodList?.count, 7)
  }
  
  func testGetPizzaMenu(){
    sut?.getMenuFor(.pizza)
    XCTAssertNotNil(self.foodList)
    XCTAssertEqual(self.foodList?.count, 5)
  }
  
  func testGetFoodTypes(){
    sut?.getMenyTypes()
    XCTAssertNotNil(self.foodTypes)
    XCTAssertEqual(self.foodTypes?.count, 2)
  }

}

extension TestMenuProvider: MenuProviderDelegate{
  func didReceiveMenyTypes(_ types: [String]) {
    self.foodTypes = types
  }
  
  
  func didReceiveMenu(_ menu: [Food]) {
    self.foodList = menu
  }
  
  
}

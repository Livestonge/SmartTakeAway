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
  var foodList: [Food]?
  
  override func setUp() {
    super.setUp()
    sut = MenuProviding()
    sut?.delegate = self
  }
  
  override func tearDown() {
    sut = nil
    foodList = nil
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

}

extension TestMenuProvider: MenuProviderDelegate{
  
  func didReceiveMenu(_ menu: [Food]) {
    self.foodList = menu
  }
  
  
}

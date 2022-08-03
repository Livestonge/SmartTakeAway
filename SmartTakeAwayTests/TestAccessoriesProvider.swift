//
//  TestAccessoriesProvider.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

import XCTest
@testable import SmartTakeAway

class TestAccessoriesProvider: XCTestCase {
  var sut: FoodAccessoryProviding?
  var accessoryList: [String: [String]]?
  
  override func setUp() {
    super.setUp()
    sut = FoodAccessoryProviding()
    sut?.delegate = self
    accessoryList = [:]
  }
  
  override func tearDown() {
    sut = nil
    accessoryList = nil
    super.tearDown()
  }
  
  func testGetAccessories(){
    sut?.getFoodAccessories()
    XCTAssertNotNil(accessoryList?["drinks"])
    XCTAssertNotNil(accessoryList?["sauces"])
    XCTAssertEqual(accessoryList?["drinks"]?.count, 6)
    XCTAssertEqual(accessoryList?["sauces"]?.count, 7)
  }

}

extension TestAccessoriesProvider: FoodAccessoryProviderDelegate{
  func didReceiveDrinkList(_ drinks: [String]) {
    self.accessoryList?["drinks"] = drinks
  }
  
  func didReceiveSausList(_ saus: [String]) {
    self.accessoryList?["sauces"] = saus
  }
  
  
}

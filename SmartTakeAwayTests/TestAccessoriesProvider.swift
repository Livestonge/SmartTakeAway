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
    sut = FoodAccessoryProviding(foodType: "")
    sut?.delegate = self
    accessoryList = [:]
  }
  
  override func tearDown() {
    sut = nil
    accessoryList = nil
    super.tearDown()
  }
  
  func testGetAccessories(){
    self.sut = FoodAccessoryProviding(foodType: "")
    self.sut?.delegate = self
    sut?.getFoodAccessories()
    XCTAssertNotNil(accessoryList?["drinks"])
    XCTAssertNotNil(accessoryList?["sauces"])
    XCTAssertEqual(accessoryList?["drinks"]?.count, 6)
    XCTAssertEqual(accessoryList?["sauces"]?.count, 7)
    XCTAssertNil(accessoryList?["taille"])
  }

  func testGetAccessoriesForPizzaCommand(){
    self.sut = FoodAccessoryProviding(foodType: "Pizza")
    self.sut?.delegate = self
    self.sut?.getFoodAccessories()
    XCTAssertNotNil(accessoryList?["drinks"])
    XCTAssertNotNil(accessoryList?["sauces"])
    XCTAssertEqual(accessoryList?["drinks"]?.count, 6)
    XCTAssertEqual(accessoryList?["sauces"]?.count, 7)
    XCTAssertEqual(accessoryList?["taille"]?.count, 3)
  }
  
}

extension TestAccessoriesProvider: FoodAccessoryProviderDelegate{
  func didReceiveDrinkList(_ drinks: [String]) {
    self.accessoryList?["drinks"] = drinks
  }
  
  func didReceiveSausList(_ saus: [String]) {
    self.accessoryList?["sauces"] = saus
  }
  
  func didReceiveTaille(_ taille: [String]) {
    self.accessoryList?["taille"] = taille
  }
}

//
//  TestSelectedFoodManager.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

import XCTest
@testable import SmartTakeAway

class TestSelectedFoodManager: XCTestCase {

  var sut: SelectedFoodManager?
  var food: Food?
  var didCompletedSelection: Bool?
  var observer: SelectedFoodObserver?
  
  override func setUp() {
    super.setUp()
    observer = SelectedFoodObserver()
    sut = SelectedFoodManager(selectedFoodObserver: observer!)
    sut?.delegate = self
  }
  
  override func tearDown() {
    sut = nil
    food = nil
    didCompletedSelection = nil
    super.tearDown()
  }
  
  func testSelectFood(){
    let food = Food(name: "O tacos simple",
                    price: Price.sandwich(8),
                    description: "merguez avec sauce fromagère",
                    image: nil)
    
    sut?.didSelect(food)
    XCTAssertNotNil(self.food)
    XCTAssertEqual(self.food?.name, "O tacos simple")
    XCTAssertEqual(self.food?.priceAmount, 8)
  }
  
  func testDidCompleteSelecting(){
    let food = Food(name: "Mexicain burger",
                    price: Price.sandwich(12),
                    description: "Frites and tomatoes",
                    image: nil)
    
    sut?.didCompletedSelecting(food)
    XCTAssertNotNil(self.didCompletedSelection)
    XCTAssertEqual(self.didCompletedSelection, true)
    XCTAssertNotNil(observer?.food)
    XCTAssertEqual(observer?.food?.name, "Mexicain burger")
  }

}

extension TestSelectedFoodManager: SelectedFoodDelegate{
  
  func didReceiveSelected(_ food: Food) {
    self.food = food
  }
  
  func didCompleteSelection() {
    self.didCompletedSelection = true
  }
  
  
}

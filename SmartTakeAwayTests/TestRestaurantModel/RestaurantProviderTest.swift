//
//  RestaurantProvider.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

import XCTest
@testable import SmartTakeAway

class RestaurantProviderTest: XCTestCase {
  var sut: RestaurantsProviding?
  var restaurants: [Restaurant]?
  
  override func setUp() {
    super.setUp()
    sut = RestaurantsProviding()
    sut?.delegate = self
  }
  
  override func tearDown() {
    sut = nil
    restaurants = nil
    super.tearDown()
  }
  
  func testGetRestaurants(){
    sut?.getRestaurants()
    XCTAssertNotNil(self.restaurants)
    XCTAssertEqual(self.restaurants?.count, 9)
  }

}

extension RestaurantProviderTest: RestaurantsProviderDelegate{
  
  func didReceive(restaurants: [Restaurant]) {
    self.restaurants = restaurants
  }
  
}

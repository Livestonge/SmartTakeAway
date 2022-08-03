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
  var restaurantObserver: RestaurantSelectionObserver?
  
  override func setUp() {
    super.setUp()
    restaurantObserver = RestaurantSelectionObserver()
    sut = RestaurantsProviding(restaurantDetailObserver: restaurantObserver!)
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
  
  func testDidSelectRestaurant(){
    let restaurant = Restaurant(name: "City burger",
                                adresse: "01 avenue de Saint Jacque 75034 Paris")
    sut?.didSelect(restaurant)
    XCTAssertEqual(restaurant, restaurantObserver?.restaurant)
    XCTAssertEqual(restaurantObserver?.restaurant?.name, "City burger")
  }

}

extension RestaurantProviderTest: RestaurantsProviderDelegate{
  
  func didReceive(restaurants: [Restaurant]) {
    self.restaurants = restaurants
  }
  
}

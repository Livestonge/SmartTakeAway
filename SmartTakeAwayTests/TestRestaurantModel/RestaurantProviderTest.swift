//
//  RestaurantProvider.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

@testable import SmartTakeAway
import XCTest

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

    func testGetRestaurants() {
        sut?.getRestaurants()
        XCTAssertNotNil(restaurants)
        XCTAssertEqual(restaurants?.count, 9)
    }
}

extension RestaurantProviderTest: RestaurantsProviderDelegate {
    func didReceive(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }
}

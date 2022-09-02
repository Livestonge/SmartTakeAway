//
//  TestRestaurantManager.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 21/08/2022.
//

@testable import SmartTakeAway
import XCTest

class TestRestaurantManager: XCTestCase {
    var sut: RestaurantManager?
    var willShowMenu: Bool?
    var willShowAlert: Bool?

    override func setUp() {
        sut = RestaurantManager(observer: RestaurantDetailObserver())
        sut?.delegate = self
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        sut?.delegate = nil
        willShowMenu = nil
        willShowAlert = nil
    }

    func testShouldChangeRestaurant() {
        let restaurant = Restaurant(name: "Victoria restaurant",
                                    adresse: "3 rue des fauvettes 77890")

        sut?.shouldChange(restaurant)
        XCTAssertNotNil(willShowMenu)
        XCTAssertNil(willShowAlert)
        XCTAssertTrue(willShowMenu!)
    }

    func testDidSelectRestaurantWithShowMenu() {
        let restaurant = Restaurant(name: "Victoria restaurant",
                                    adresse: "3 rue des fauvettes 77890")
        sut?.didSelectRestaurant(restaurant)
        XCTAssertNotNil(willShowMenu)
        XCTAssertNil(willShowAlert)
        XCTAssertTrue(willShowMenu!)
    }

    func testDidSelectWithAlert() {
        let restaurant_1 = Restaurant(name: "Victoria restaurant",
                                      adresse: "3 rue des fauvettes 77890")
        sut?.didSelectRestaurant(restaurant_1)
        let restaurant = Restaurant(name: "Burger King",
                                    adresse: "3 rue des fauvettes 77890")
        sut?.didSelectRestaurant(restaurant)
        XCTAssertNil(willShowMenu)
        XCTAssertNotNil(willShowAlert)
        XCTAssertTrue(willShowAlert!)
    }
}

extension TestRestaurantManager: RestaurantManagerDelegate {
    func showMenu() {
        willShowAlert = nil
        willShowMenu = true
    }

    func showAlertFor(_: Restaurant) {
        willShowMenu = nil
        willShowAlert = true
    }

    func showMessage() {
        // ....
    }
}

class RestaurantDetailObserver: RestaurantDetailObservable {
    var currentRestaurant: Restaurant?

    func didSelectRestaurant(_ restaurant: Restaurant) {
        currentRestaurant = restaurant
    }

    func getSelectedRestaurant() -> Restaurant? {
        return currentRestaurant
    }

    func hasFoodInPreparation() -> Bool {
        return false
    }

    func deleteOrder() {
        // ...
    }
}

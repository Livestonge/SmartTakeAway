//
//  TestAccessoriesProvider.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

@testable import SmartTakeAway
import XCTest

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

    func testGetAccessories() {
        sut = FoodAccessoryProviding(foodType: "")
        sut?.delegate = self
        sut?.getFoodAccessories()
        XCTAssertNotNil(accessoryList?["drinks"])
        XCTAssertNotNil(accessoryList?["sauces"])
        XCTAssertEqual(accessoryList?["drinks"]?.count, 6)
        XCTAssertEqual(accessoryList?["sauces"]?.count, 7)
        XCTAssertNil(accessoryList?["taille"])
    }

    func testGetAccessoriesForPizzaCommand() {
        sut = FoodAccessoryProviding(foodType: "Pizza")
        sut?.delegate = self
        sut?.getFoodAccessories()
        XCTAssertNotNil(accessoryList?["drinks"])
        XCTAssertNotNil(accessoryList?["sauces"])
        XCTAssertEqual(accessoryList?["drinks"]?.count, 6)
        XCTAssertEqual(accessoryList?["sauces"]?.count, 7)
        XCTAssertEqual(accessoryList?["taille"]?.count, 3)
    }
}

extension TestAccessoriesProvider: FoodAccessoryProviderDelegate {
    func didReceiveDrinkList(_ drinks: [String]) {
        accessoryList?["drinks"] = drinks
    }

    func didReceiveSausList(_ saus: [String]) {
        accessoryList?["sauces"] = saus
    }

    func didReceiveTaille(_ taille: [String]) {
        accessoryList?["taille"] = taille
    }
}

//
//  SmartTakeAwayTests.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 22/07/2022.
//

@testable import SmartTakeAway
import XCTest

class GetStoredDataTests: XCTestCase {
    func testIfRestaurantFileExist() {
        let file = Bundle.main.url(forResource: "Restaurants", withExtension: "plist")
        XCTAssertNotNil(file)
        XCTAssertEqual(file?.lastPathComponent, "Restaurants.plist")
    }

    func testIfMenyFileExist() {
        let file = Bundle.main.url(forResource: "Meny", withExtension: "plist")
        XCTAssertNotNil(file)
        XCTAssertEqual(file?.lastPathComponent, "Meny.plist")
    }

    func testIfAccessoriesFileExist() {
        let file = Bundle.main.url(forResource: "DAndSData", withExtension: "plist")
        XCTAssertNotNil(file)
        XCTAssertEqual(file?.lastPathComponent, "DAndSData.plist")
    }

    func testGetRestaurants() {
        let sut: StoredData<[Restaurant]> = .init(fileName: "Restaurants")
        let model = sut.model
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.count, 9)
    }

    func testGetAccessories() {
        let sut: StoredData<[String: [String]]> = .init(fileName: "DAndSData")
        let model = sut.model
        let drinks = model?["Drink"]
        let sauces = model?["Sauce"]
        XCTAssertNotNil(model)
        XCTAssertNotNil(drinks)
        XCTAssertEqual(drinks?.count, 6)
        XCTAssertNotNil(sauces)
        XCTAssertEqual(sauces?.count, 7)
    }

    func testGetMeny() {
        let sut: StoredData<[String: [Food]]> = .init(fileName: "Meny")
        let model = sut.model
        let sandwiches = model?["Sandwiches"]
        let pizza = model?["Pizza"]
        XCTAssertNotNil(model)
        XCTAssertNotNil(sandwiches)
        XCTAssertEqual(sandwiches?.count, 7)
        XCTAssertNotNil(pizza)
        XCTAssertEqual(pizza?.count, 5)
    }
}

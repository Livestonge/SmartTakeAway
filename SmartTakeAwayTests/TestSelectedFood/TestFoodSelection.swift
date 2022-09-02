//
//  TestFoodSelection.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 21/08/2022.
//

@testable import SmartTakeAway
import XCTest

class TestFoodSelection: XCTestCase {
    var sut: FoodSelectionManager?
    var currentUserSelection: UserSelection?

    override func setUp() {
        sut = FoodSelectionManager()
        sut?.delegate = self
        currentUserSelection = nil
        super.setUp()
    }

    override func tearDown() {
        sut?.delegate = nil
        sut = nil
        currentUserSelection = nil
        super.tearDown()
    }

    func testDidSelect() {
        let drink = Accessory(id: 1,
                              type: "Drink",
                              name: "Sprite")
        let sauce = Accessory(id: 2,
                              type: "Sauce",
                              name: "Harissa")

        sut?.didSelect(drink)
        XCTAssertNotNil(currentUserSelection)
        XCTAssertEqual(currentUserSelection?.drink?.name, drink.name)
        sut?.didSelect(sauce)
        XCTAssertEqual(currentUserSelection?.sauces.0?.name, sauce.name)
    }
}

extension TestFoodSelection: AccessoriesManagerDelegate {
    func didReceive(selection: UserSelection) {
        currentUserSelection = selection
    }
}

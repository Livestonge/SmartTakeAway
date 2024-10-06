//
//  TestSelectedFoodManager.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

@testable import SmartTakeAway
import XCTest

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

    func testDidCompleteSelecting() {
        let food = Food(name: "Mexicain burger",
                        price: Price.sandwich(12),
                        description: "Frites and tomatoes",
                        image: nil)

        let selectedFood = SelectedFood(type: "Sandwich", food: food)
        sut?.didCompletedSelecting(selectedFood)
        XCTAssertNotNil(didCompletedSelection)
        XCTAssertEqual(didCompletedSelection, true)
        XCTAssertNotNil(observer?.food)
        XCTAssertEqual(observer?.food?.name, "Mexicain burger")
    }
}

extension TestSelectedFoodManager: SelectedFoodDelegate {
    func didReceiveSelected(_ food: Food) {
        self.food = food
    }

    func didCompleteSelection() {
        didCompletedSelection = true
    }
}

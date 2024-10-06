//
//  TestSelectedFood.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 29/08/2022.
//

@testable import SmartTakeAway
import XCTest

class TestSelectedFood: XCTestCase {
    var sut: SelectedFood?

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testUpdatesPriceForSandwich() {
        let food = Food(name: "Mexicain burger",
                        price: Price.sandwich(12),
                        description: "Frites and tomatoes",
                        image: nil)
        sut = SelectedFood(type: "Sandwich",
                           food: food)
        sut?.updatePriceWith()
        XCTAssertEqual(sut?.price, food.priceAmount)
        sut?.updatePriceWith(PizzaSize.large.rawValue)
        XCTAssertEqual(sut?.price, food.priceAmount)
    }

    func testUpdatesPriceForPizza() {
        let food = Food(name: "Mozzarella",
                        price: Price.pizza(medium: 8, grande: 10, large: 12),
                        description: "Mozzarella, pesto, tomatoes",
                        image: nil)
        sut = SelectedFood(type: "Pizza",
                           food: food)
        sut?.updatePriceWith()
        XCTAssertEqual(sut?.price, food.priceAmount)
        sut?.updatePriceWith(PizzaSize.grande.rawValue)
        XCTAssertEqual(sut?.price, 10)
    }

    func testUpdateAccessories() {
        let food = Food(name: "Mexicain burger",
                        price: Price.sandwich(12),
                        description: "Frites and tomatoes",
                        image: nil)
        sut = SelectedFood(type: "Sandwich",
                           food: food)
        let drink = Accessory(id: 1,
                              type: "Drink",
                              name: "Sprite")
        let sauce_1 = Accessory(id: 2,
                                type: "Sauce",
                                name: "Harissa")
        let sauce_2 = Accessory(id: 2,
                                type: "Sauce",
                                name: "Ketchup")

        let userSelection = UserSelection(drink: drink, size: nil, sauces: (sauce_1, sauce_2))
        sut?.updateAcessories(userSelection: userSelection)
        XCTAssertEqual(sut?.food.sauce_1 ?? "", "Harissa")
        XCTAssertEqual(sut?.food.sauce_2 ?? "", "Ketchup")
        XCTAssertEqual(sut?.food.drink ?? "", "Sprite")
    }
}

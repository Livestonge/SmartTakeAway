//
//  OrderBankTest.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 02/08/2022.
//

@testable import SmartTakeAway
import XCTest

class OrderBankTest: XCTestCase {
    var sut: OrderBank?

    override func setUp() {
        super.setUp()
        sut = OrderBank.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func instantiateAnOrderBankWithRestaurant() -> OrderBank {
        let bank = OrderBank.shared
        let restaurant = Restaurant(name: "City burger",
                                    adresse: "01 avenue de Saint Jacque 75034 Paris")

        bank.didSelectRestaurant(restaurant)
        return bank
    }

    func testInsertRestaurant() {
        let restaurant = Restaurant(name: "City burger",
                                    adresse: "01 avenue de Saint Jacque 75034 Paris")

        sut?.didSelectRestaurant(restaurant)

        let order = sut?.getMadeOrder()
        XCTAssertNotNil(order)
        XCTAssertEqual(order?.restaurantName, "City burger")
    }

    func testGetCurrentRestaurant() {
        _ = instantiateAnOrderBankWithRestaurant()
        let restaurant = sut?.getSelectedRestaurant()
        XCTAssertNotNil(restaurant)
        XCTAssertEqual(restaurant?.name, "City burger")
    }

    func testDidSelectFood() {
        sut = instantiateAnOrderBankWithRestaurant()

        var food = Food(name: "O tacos simple",
                        price: Price.sandwich(8),
                        description: "merguez avec sauce fromagère",
                        image: nil)

        food.drink = "Pepsi"
        food.sauce_1 = "Algerienne"
        food.sauce_2 = "Harissa"

        let selectedFood = SelectedFood(type: "Sandwich",
                                        food: food,
                                        price: food.priceAmount)

        sut?.didCompletedSelecting(selectedFood)
        let order = sut?.getMadeOrder()
        let storedFood = order?.foodsList.first

        XCTAssertNotNil(order)
        XCTAssertNotNil(storedFood)
        XCTAssertEqual(storedFood?.name, "O tacos simple")
        XCTAssertEqual(storedFood?.price, 8)
    }

    func testDeletingOrder() {
        sut = instantiateAnOrderBankWithRestaurant()
        var food_1 = Food(name: "O tacos simple",
                          price: Price.sandwich(12),
                          description: "merguez avec sauce fromagère",
                          image: nil)

        food_1.drink = "Pepsi"
        food_1.sauce_1 = "Algerienne"
        food_1.sauce_2 = "Harissa"
        let selectedFood_1 = SelectedFood(type: "Sandwich",
                                          food: food_1,
                                          price: food_1.priceAmount)
        sut?.didCompletedSelecting(selectedFood_1)

        var food_2 = Food(name: "Kebab assiette",
                          price: Price.sandwich(12),
                          description: "avec frites, tomates et onion",
                          image: nil)

        food_2.drink = "Ice tea"
        food_2.sauce_1 = "Algerienne"
        food_2.sauce_2 = "Harissa"
        let selectedFood_2 = SelectedFood(type: "Sandwich", food: food_2)
        sut?.didCompletedSelecting(selectedFood_2)
        sut?.deleteOrder()
        XCTAssertNil(sut?.getMadeOrder())
    }

    func testDeleteSelectedFood() {
        sut = instantiateAnOrderBankWithRestaurant()
        var food_1 = Food(name: "O tacos simple",
                          price: Price.sandwich(12),
                          description: "merguez avec sauce fromagère",
                          image: nil)

        food_1.drink = "Pepsi"
        food_1.sauce_1 = "Algerienne"
        food_1.sauce_2 = "Harissa"
        let selectedFood_1 = SelectedFood(type: "Sandwich",
                                          food: food_1,
                                          price: food_1.priceAmount)
        sut?.didCompletedSelecting(selectedFood_1)

        var food_2 = Food(name: "Kebab assiette",
                          price: Price.sandwich(12),
                          description: "avec frites, tomates et onion",
                          image: nil)

        food_2.drink = "Ice tea"
        food_2.sauce_1 = "Algerienne"
        food_2.sauce_2 = "Harissa"
        let selectedFood_2 = SelectedFood(type: "Sandwich", food: food_2)
        sut?.didCompletedSelecting(selectedFood_2)
        guard let orderedFood = sut?.getMadeOrder()?.foodsList.first
        else {
            XCTFail()
            return
        }
        sut?.delete(orderedFood)
        XCTAssertEqual(sut?.getMadeOrder()?.foodsList.count, 1)
        XCTAssertFalse(sut?.getMadeOrder()?.foodsList.contains(where: { $0.name == food_1.name }) ?? true)
    }

    func testHasOrderFood() {
        sut = instantiateAnOrderBankWithRestaurant()
        var food_1 = Food(name: "O tacos simple",
                          price: Price.sandwich(12),
                          description: "merguez avec sauce fromagère",
                          image: nil)

        food_1.drink = "Pepsi"
        food_1.sauce_1 = "Algerienne"
        food_1.sauce_2 = "Harissa"
        let selectedFood_1 = SelectedFood(type: "Sandwich",
                                          food: food_1,
                                          price: food_1.priceAmount)
        sut?.didCompletedSelecting(selectedFood_1)
        sut?.didValidateOrder()
        let didOrdered = sut?.hasFoodInPreparation()
        XCTAssertNotNil(didOrdered)
        XCTAssertTrue(didOrdered!)
    }

    func testFoodList() {
        sut = instantiateAnOrderBankWithRestaurant()
        var food_1 = Food(name: "O tacos simple",
                          price: Price.sandwich(12),
                          description: "merguez avec sauce fromagère",
                          image: nil)

        food_1.drink = "Pepsi"
        food_1.sauce_1 = "Algerienne"
        food_1.sauce_2 = "Harissa"
        let selectedFood_1 = SelectedFood(type: "Sandwich",
                                          food: food_1,
                                          price: food_1.priceAmount)
        sut?.didCompletedSelecting(selectedFood_1)
        let isEmpty = sut?.isFoodListEmpty()
        XCTAssertNotNil(isEmpty)
        XCTAssertFalse(isEmpty!)
    }
}

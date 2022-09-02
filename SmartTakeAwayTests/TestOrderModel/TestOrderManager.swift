//
//  TestOrderManager.swift
//  SmartTakeAwayTests
//
//  Created by Awaleh Moussa Hassan on 03/08/2022.
//

@testable import SmartTakeAway
import XCTest

class TestOrderManager: XCTestCase {
    var sut: OrderManager?
    var order: Order?
    var observer: OrderObserver?
    var foodList: [OrderedFood]?

    override func setUp() {
        super.setUp()
        observer = OrderObserver()
        sut = OrderManager(orderObserver: observer!)
        sut?.delegate = self
        foodList = []
    }

    override func tearDown() {
        sut = nil
        observer = nil
        order = nil
        foodList = nil
        super.tearDown()
    }

    func testGetOrder() {
        sut?.getTheListOfFood()
        XCTAssertNotNil(foodList)
        XCTAssertFalse(foodList!.isEmpty)
    }

    func testOrderInitialStatus() {
        sut?.getTheListOfFood()
        XCTAssertNotNil(foodList)
        XCTAssertTrue(foodList!.allSatisfy { $0.status == .toBeConfirmed })
    }

    func testDidValidate() {
        sut?.getTheListOfFood()
        XCTAssertNotNil(foodList)
        XCTAssertTrue(foodList!.allSatisfy { $0.status == .toBeConfirmed })
        foodList = []
        sut?.didValidateOrder()
        XCTAssertFalse(foodList!.isEmpty)
        XCTAssertTrue(foodList!.allSatisfy { $0.status == .preparation })
    }

    func testDeleteFood() {
        sut?.getTheListOfFood()
        let count = foodList?.count ?? 0
        XCTAssertNotNil(foodList)
        XCTAssertFalse(foodList!.isEmpty)
        XCTAssertEqual(foodList!.count, count)
        let food = foodList!.first!
        foodList = []
        sut?.delete(food)
        sut?.getTheListOfFood()
        XCTAssertFalse(foodList!.isEmpty)
        XCTAssertFalse(foodList!.contains(where: { $0.name == food.name }))
    }

    func testDeleteOrder() {
        order = observer?.getMadeOrder()
        XCTAssertNotNil(order)
        sut?.deleteOrder()
        order = observer?.getMadeOrder()
        XCTAssertNil(order)
    }
}

extension TestOrderManager: OrderProviderDelegate {
    func didReceiveFood(_ list: [OrderedFood], withStatus _: OrderStatus) {
        foodList?.append(contentsOf: list)
    }

    func didReceiveRestaurant(_: Restaurant) {
        //
    }

    func showAlertWith(message _: String) {
        //
    }

    func didReceiveOrder(_ order: Order?) {
        self.order = order
    }
}

//
//  OrdersProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 27/07/2022.
//

import Foundation
import UIKit
import UserNotifications

class OrderManager: OrderProvider {
    // Used to communicate with viewControllers
    weak var delegate: OrderProviderDelegate?
    // Used for storing the user's selections
    var orderObserver: OrderObservable
    // Used for checking periodically the states of a food in preparation.
    private weak var timer: Timer?
    // BackgroundTask used when the app use to the background while there is food in preparation.
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    // Variable to track the notification to post when the user's order is prepared.
    private var didPostNotification = false
    // Variable used to know if the oderpage is currently displayed or not.
    var isDisplayingOrderPage = true

    init(orderObserver: OrderObservable) {
        self.orderObserver = orderObserver
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        print("OrderManager is deInitialize.")
        NotificationCenter.default.removeObserver(self)
    }

    // method used to notify the system that we need time to finish some processing while app in the background
    @objc
    func appMovedToBackground() {
        isDisplayingOrderPage = false
        let isTimerRunning = timer?.isValid == true
        let isBackgroundTaskValid = backgroundTask != .invalid
        if isTimerRunning, !isBackgroundTaskValid {
            registerBackgroundTask()
        }
    }

    @objc
    func appMovedToForeground() {
        endBackgroundTask()
    }

    func willShowOrderPage() {
        isDisplayingOrderPage = true
    }

    func orderPageWillDisappear() {
        isDisplayingOrderPage = false
    }

    func registerBackgroundTask() {
        // notifies the system that we may need time to finish some processing
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            print("BackgroundTask ending....")
            self?.endBackgroundTask()
        }
    }

    func endBackgroundTask() {
        backgroundTask = .invalid
    }

    func didValidateOrder() {
        // Notifies the observer.
        orderObserver.didValidateOrder()
        getTheListOfFood()
        // Instantiates the timer and execute the getMadeOrder method every 2 secs.
        timer = Timer.scheduledTimer(withTimeInterval: .init(2),
                                     repeats: true,
                                     block: { [weak self] _ in self?.getTheListOfFood() })
    }

    func getTheListOfFood() {
        let order = orderObserver.getMadeOrder()

        let toBeConfirmedList = order?.foodsList.filter { $0.status == .toBeConfirmed } ?? []
        let pendingList = order?.foodsList.filter { $0.status == .preparation } ?? []
        let finishedList = order?.foodsList.filter { $0.status == .finished } ?? []

        delegate?.didReceiveFood(toBeConfirmedList,
                                 withStatus: .toBeConfirmed)
        delegate?.didReceiveFood(pendingList,
                                 withStatus: .preparation)
        delegate?.didReceiveFood(finishedList,
                                 withStatus: .finished)
        let restaurant = Restaurant(name: order?.restaurantName ?? "",
                                    adresse: order?.restaurantAdress ?? "")
        delegate?.didReceiveRestaurant(restaurant)

        shouldInvalidateTimer(pendingList.isEmpty)
        shouldEndBackgroundTask(pendingList.isEmpty)
        shouldPostNotification(pendingList.isEmpty && !finishedList.isEmpty)
    }

    private func shouldInvalidateTimer(_ state: Bool) {
        if state {
            timer?.invalidate()
        }
    }

    private func shouldEndBackgroundTask(_ state: Bool) {
        if state {
            endBackgroundTask()
        }
    }

    private func shouldPostNotification(_ state: Bool) {
        if state {
            postNotification()
            didPostNotification = state
            return
        }
        didPostNotification = state
    }

    private func postNotification() {
        guard didPostNotification == false, isDisplayingOrderPage == false else { return }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "Finished"
                content.body = "Your order is ready🍽"

                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: nil)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Notification error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func delete(_ food: OrderedFood) {
        if food.status == .preparation {
            delegate?.showAlertWith(message: "You cannot delete an item under preparation")
            return
        }
        orderObserver.delete(food)
        getTheListOfFood()
    }

    func deleteOrder() {
        orderObserver.deleteOrder()
    }
}

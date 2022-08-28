//
//  OrdersProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 27/07/2022.
//

import Foundation

class OrderManager: OrderProvider{
  
  // Used to communicate with viewControllers
  weak var delegate: OrderProviderDelegate?
  // Used for storing the user's selections
  var orderObserver: OrderObservable
  // Used for checking periodically the states of a food in preparation.
  weak private var timer: Timer?
  
  init(orderObserver: OrderObservable){
    self.orderObserver = orderObserver
    
  }
  
  func didValidateOrder(){
    // Notifies the observer.
    self.orderObserver.didValidateOrder()
    getTheListOfFood()
    // Instantiates the timer and execute the getMadeOrder method every 2 secs.
    self.timer = Timer.scheduledTimer(withTimeInterval: .init(2),
                                      repeats: true,
                                      block: { [weak self] _ in self?.getTheListOfFood() })
    
  }
  
  func getTheListOfFood() {
    
    let order = self.orderObserver.getMadeOrder()
    
    let toBeConfirmedList = order?.foodsList.filter({ $0.status == .toBeConfirmed }) ?? []
    let pendingList = order?.foodsList.filter({ $0.status == .preparation }) ?? []
    let finishedList = order?.foodsList.filter({ $0.status == .finished }) ?? []
    
    delegate?.didReceiveFood(toBeConfirmedList,
                             withStatus: .toBeConfirmed)
    delegate?.didReceiveFood(pendingList,
                             withStatus: .preparation)
    delegate?.didReceiveFood(finishedList,
                             withStatus: .finished)
    let restaurant = Restaurant(name: order?.restaurantName ?? "",
                                adresse: order?.restaurantAdress ?? "")
    delegate?.didReceiveRestaurant(restaurant)
    
    if pendingList.isEmpty{
      self.timer?.invalidate()
    }
    
  }
  
  func delete(_ food: OrderedFood){
    if food.status == .preparation{
      delegate?.showAlertWith(message: "You cannot delete an item under preparation")
      return
    }
    self.orderObserver.delete(food)
    self.getTheListOfFood()
  }
  
  func deleteOrder(){
    self.orderObserver.deleteOrder()
  }
  
}

//
//  OrdersProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 27/07/2022.
//

import Foundation

class OrderManager: OrderProvider{
  
  weak var delegate: OrderProviderDelegate?
  var orderObserver: OrderObservable
  weak private var timer: Timer?
  
  init(orderObserver: OrderObservable){
    self.orderObserver = orderObserver
    
  }
  
  func didValidateOrder(){
    self.orderObserver.didValidateOrder()
    getMadeOrder()
    self.timer = Timer.scheduledTimer(withTimeInterval: .init(2),
                                      repeats: true,
                                      block: { [weak self] _ in self?.getMadeOrder() })
    
  }
  
  func getMadeOrder() {
    
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
    self.getMadeOrder()
  }
  
  func deleteOrder(){
    self.orderObserver.deleteOrder()
  }
  
}

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
  
  init(orderObserver: OrderObservable){
    self.orderObserver = orderObserver
  }
  
  func getMadeOrder() {
    let order = self.orderObserver.getMadeOrder()
    updateDelegateWith(order)
  }
  
  func updateDelegateWith(_ order: Order?){
    delegate?.didReceiveOrder(order)
  }
  
  func deleteFoodAt(_ index: Int){
    self.orderObserver.deleteFoodAt(index)
    guard let order = self.orderObserver.getMadeOrder() else { return }
    updateDelegateWith(order)
  }
  
  func deleteOrder(){
    self.orderObserver.deleteOrder()
  }
  
}

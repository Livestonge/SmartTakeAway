//
//  OrdersProvider.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 27/07/2022.
//

import Foundation

class OrderManager: OrderProvider{
  
  weak var delegate: OrderProviderDelegate?
  private var order: Order
  
  init(){
    self.order = Order.shared
  }
  
  func getMadeOrder() {
    delegate?.didReceiveOrder(order)
  }
  
  func deleteFoodAt(_ index: Int){
    self.order.ordersList.remove(at: index)
    delegate?.didReceiveOrder(order)
  }
}

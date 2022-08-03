//
//  Order protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 27/07/2022.
//

import Foundation

protocol OrderProvider{
  var delegate: OrderProviderDelegate? { get set }
  func getMadeOrder()
  func deleteFoodAt(_ index: Int)
  func deleteOrder()
}

protocol OrderObservable{
  func getMadeOrder() -> Order?
  func deleteFoodAt(_ index: Int)
  func deleteOrder()
}
protocol OrderProviderDelegate: AnyObject{
  func didReceiveOrder(_ order: Order?)
}

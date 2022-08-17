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
  func delete(_ food: OrderedFood)
  func deleteOrder()
  func didValidateOrder()
}

protocol OrderObservable{
  func getMadeOrder() -> Order?
  func delete(_ food: OrderedFood)
  func deleteOrder()
  func didValidateOrder()
}
protocol OrderProviderDelegate: AnyObject{
  func didReceiveFood(_ list: [OrderedFood], withStatus: OrderStatus)
  func didReceiveRestaurant(_ restaurant: Restaurant)
  func showAlertWith(message: String)
}

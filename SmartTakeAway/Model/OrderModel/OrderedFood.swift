//
//  OrderedFood.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 11/08/2022.
//

import Foundation


struct OrderedFood{
  let name: String
  let price: Double
  let drink: String
  let sauces: String
  var status: OrderStatus = .toBeConfirmed
  }

enum OrderStatus {
  case preparation, finished, toBeConfirmed
}

//
//  Menu protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 24/07/2022.
//

import Foundation

protocol MenuProvider: AnyObject {
  var delegate: MenuProviderDelegate? {get set}
  func getMenuFor(_ menu: MenuType)
  func getMenyTypes()
}

protocol MenuProviderDelegate: AnyObject {
  func didReceiveMenu(_ menu: [Food])
  func didReceiveMenyTypes(_ types: [String])
}

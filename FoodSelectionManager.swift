//
//  NewManager.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 07/08/2022.
//

import Foundation


struct Accessory{
  let id: Int
  let type: String
  let name: String
}

struct UserSelection{
  var drink: Accessory? = nil
  var size: Accessory? = nil
  var sauces: (Accessory?, Accessory?) = (nil, nil)
}

protocol NewManagerDelegate: AnyObject {
  func didReceive(selection: UserSelection)
}

class FoodSelectionManager{
  
  var userSelection: UserSelection
  weak var delegate: NewManagerDelegate?
  
  init(){
    userSelection = UserSelection()
  }
  
  func didSelect(_ accessory: Accessory){
    switch accessory.type {
    case "Drink":
      self.userSelection.drink = accessory
    case "Taille":
      self.userSelection.size = accessory
    case "Sauce":
      switch self.userSelection.sauces{
      case (nil, nil):
        self.userSelection.sauces = (accessory, nil)
      case (let currentSauce, nil):
        self.userSelection.sauces.1 = currentSauce?.id == accessory.id ? nil : accessory
      case (nil, let currentSauce):
        self.userSelection.sauces.0 = currentSauce?.id == accessory.id ? nil : accessory
      case ( _, _):
        if self.userSelection.sauces.0?.id == accessory.id{
          self.userSelection.sauces.0 = nil
        }else if self.userSelection.sauces.1?.id == accessory.id{
          self.userSelection.sauces.1 = nil
        }else{
          self.userSelection.sauces.1 = accessory
        }
      }
    default: break
    }
    delegate?.didReceive(selection: userSelection)
  }
  
}

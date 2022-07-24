//
//  Menu.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation

class MenuProviding: MenuProvider{
  
  weak var delegate: MenuProviderDelegate?
  private var menuList: [String: [Food]] = [:]
  
  init(){
    getMenuList()
  }
  
  private func getMenuList() {
    self.menuList = StoredData<[String:[Food]]>(fileName: "Meny").model ?? [:]
  }
  
  func getMenuFor(_ menu: MenuType) {
    let menu = menuList[menu.rawValue.capitalized] ?? []
    delegate?.didReceiveMenu(menu)
  }
}



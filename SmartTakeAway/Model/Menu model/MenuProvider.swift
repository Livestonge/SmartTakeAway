//
//  Menu.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation

class MenuProviding: MenuProvider {
    // Propriety used to communicate with a viewController.
    weak var delegate: MenuProviderDelegate?
    // Variable for the menu list.
    private var menuList: [String: [Food]] = [:]

    init() {
        // we get the stored menuList during initialization.
        getMenuList()
    }

    // Load the saved menuList.
    private func getMenuList() {
        menuList = StoredData<[String: [Food]]>(fileName: "Meny").model ?? [:]
    }

    // Method used to access a specific type of menu.
    func getMenuFor(_ menu: MenuType) {
        let menu = menuList[menu.rawValue.capitalized] ?? []
        delegate?.didReceiveMenu(menu)
    }

    func getMenyTypes() {
        let keys = menuList.keys.map { $0 }
        delegate?.didReceiveMenyTypes(keys)
    }
}

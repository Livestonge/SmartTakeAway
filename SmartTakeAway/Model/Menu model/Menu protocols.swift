//
//  Menu protocols.swift
//  SmartTakeAway
//
//  Created by Awaleh Moussa Hassan on 24/07/2022.
//

import Foundation
// Protocol used to group the requirements for an object providing the menu.
protocol MenuProvider: AnyObject {
    var delegate: MenuProviderDelegate? { get set }
    func getMenuFor(_ menu: MenuType)
    func getMenyTypes()
}

// Protocol used to group the requirements for an object which communicates with an MenuProvider.
protocol MenuProviderDelegate: AnyObject {
    func didReceiveMenu(_ menu: [Food])
    func didReceiveMenyTypes(_ types: [String])
}

//
//  Food.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation
// Object for representing the detail of basic food.
struct Food: Decodable {
    let name: String
    let price: Price
    let description: String
    let image: String?
    var drink: String?
    var sauce_1: String?
    var sauce_2: String?

    var priceAmount: Double {
        switch price {
        case let .sandwich(sandwichPrice):
            return sandwichPrice
        case .pizza(medium: let mediumPrice, grande: _, large: _):
            return mediumPrice
        }
    }
}

enum PizzaSize: Int {
    case medium, grande, large
}

// The price of pizza depends of his size.
enum Price {
    case sandwich(Double), pizza(medium: Double, grande: Double, large: Double)

    enum CodingKeys: CodingKey {
        case sandwich, pizza
    }

    enum PizzaCodingKeys: CodingKey {
        case medium, grande, large
    }
}

// Manual implementation of Decodable
extension Price: Decodable {
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        let key = container?.allKeys.first
        switch key {
        case .sandwich:
            let sandwichPrice = try? container?.decode(Double.self, forKey: .sandwich)
            self = .sandwich(sandwichPrice ?? 0)
        case .pizza:
            let nestedContainer = try? container?.nestedContainer(keyedBy: PizzaCodingKeys.self,
                                                                  forKey: .pizza)
            let mediumPrice = try? nestedContainer?.decode(Double.self, forKey: .medium)
            let grandePrice = try? nestedContainer?.decode(Double.self, forKey: .grande)
            let largePrice = try? nestedContainer?.decode(Double.self, forKey: .large)
            self = .pizza(medium: mediumPrice ?? 0,
                          grande: grandePrice ?? 0,
                          large: largePrice ?? 0)
        default:
            throw DecodingError.dataCorrupted(DecodingError
                .Context(codingPath: container!.codingPath,
                         debugDescription: "Unable to decode Price"))
        }
    }
}

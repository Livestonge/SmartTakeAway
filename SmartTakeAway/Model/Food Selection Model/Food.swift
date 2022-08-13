//
//  Food.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 29/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation

struct Food: Decodable{
    
    let name: String
    let price: Price
    let description: String
    let image: String?
    var drink: String?
    var sauce_1: String?
    var sauce_2: String?
  
  
    var priceAmount: Double{
        switch price {
        case .sandwich(let sandwichPrice):
            return sandwichPrice
        case .pizza(medium: let mediumPrice, grande: _, large: _):
            return mediumPrice
        }
    }
}

enum PizzaSize: Int {
  case medium, grande, large
}
enum Price{
    case sandwich(Double), pizza(medium:Double, grande: Double, large: Double)
    
    enum CodingKeys: CodingKey{
        case sandwich, pizza
    }
    
    enum PizzaCodingKeys: CodingKey{
        case medium, grande, large
    }
}

extension Price: Decodable{
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        let key = container?.allKeys.first
        switch key{
        case .sandwich:
            let sandwichPrice = try? container?.decode(Double.self, forKey: .sandwich)
            self = .sandwich(sandwichPrice ?? 0)
        case .pizza:
            let nestedContainer = try? container?.nestedContainer(keyedBy: PizzaCodingKeys.self,
                                                                 forKey: .pizza)
            let mediumPrice = (try? nestedContainer?.decode(Double.self, forKey: .medium)) ?? 0
            let grandePrice = (try? nestedContainer?.decode(Double.self, forKey: .grande)) ?? 0
            let largePrice = (try? nestedContainer?.decode(Double.self, forKey: .large)) ?? 0
            self = .pizza(medium: mediumPrice, grande: grandePrice, large: largePrice)
        default:
            throw DecodingError.dataCorrupted(DecodingError
                                                .Context(codingPath: container!.codingPath,
                                                         debugDescription: "Unable to decode Price"))
        }
    }
    
}

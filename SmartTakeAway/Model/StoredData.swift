//
//  RestaurantList.swift
//  Fadira
//
//  Created by awaleh moussa hassan on 10/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation

// Generic object used to retrieve data stored in the app.
struct StoredData<Model: Decodable> {
    // Variable of the generic type Model for the data to retrieve.
    var model: Model?

    // Intiantiate an instance of this object with the name of a file.
    init(fileName: String) {
        model = loadDataFrom(fileName: fileName)
    }

    // Method used to retrieve the app data.
    private func loadDataFrom(fileName: String, decoder: PropertyListDecoder = .init()) -> Model? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist")
        else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let model = try decoder.decode(Model.self, from: data)
            return model
        } catch {
            return nil
        }
    }
}

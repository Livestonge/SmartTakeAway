//
//  RestaurantList.swift
//  Fadira
//
//  Created by awaleh moussa hassan on 10/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import Foundation


struct StoredData<Model: Decodable>{
    
    var model: Model?
    
    init(fileName: String){
        self.model = loadDataFrom(fileName: fileName)
    }
    
    private func loadDataFrom(fileName: String, decoder: PropertyListDecoder = .init()) -> Model?{
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist")
        else {return nil}
        do{
            let data = try Data(contentsOf: url)
            let model = try decoder.decode(Model.self, from: data)
            return model
        }catch{
            return nil
        }
    }
}

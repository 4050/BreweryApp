//
//  BreweryModel.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import Foundation

struct Brewery {
    var name: String?
    var description: String?
    var image: Data?
}

class BreweryStorageModel {
    
    private let storageBrewery: BreweryStorageService
    init(storageBrewery: BreweryStorageService) {
        self.storageBrewery = storageBrewery
    }
   
    func getBreweries() -> [ManagedBrewery?] {
        let breweries = storageBrewery.getBreweries()
        return breweries
    }
    
    func saveBrewery(brewery: Brewery) {
        storageBrewery.saveBrewery(brewery: brewery)
    }
    
    
}

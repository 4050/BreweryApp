//
//  BeerGradeModel.swift
//  BreweryApp
//
//  Created by Stanislav on 03.04.2021.
//

import Foundation

struct BeerGrade {
    var name: String?
    var description: String?
    var image: Data?
}

class BeerGradeStorageModel {
    
    private let storageBeerGrade: BreweryStorageService
    
    init(storageBeerGrade: BreweryStorageService) {
        self.storageBeerGrade = storageBeerGrade
    }
    
    func getBeersGrades() -> [ManagedBeersGrades?] {
        let breweries = storageBeerGrade.getBeersGrades()
        return breweries
    }
    
    func saveBeerGrade(beerGrade: BeerGrade, brewery: ManagedBrewery) {
        storageBeerGrade.saveBeerGrade(beerGrade: beerGrade, brewery: brewery)
    }
    
    
}

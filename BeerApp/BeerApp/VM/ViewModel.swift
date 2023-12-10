//
//  ViewModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

enum BrandType: String, CaseIterable, Identifiable {
    case nacionales, importadas
    var id: String { self.rawValue }
}

enum BeerType: String, CaseIterable, Identifiable {
    case lager, pilsen, IPA, pale_Ale
    var id: String { self.rawValue }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

enum SortField: String, CaseIterable {
    case name, grades, calories
}

final class ViewModel: ObservableObject {
    @Published var brands: [Brand] = []
    @Published var favorites: [Beer] = []
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    @Published var type: BrandType = .nacionales
    @Published var typeBeer: BeerType = .lager
    @Published var title: String = ""
    @Published var grades: String = ""
    @Published var cal: String = ""
    
    @Published var selectedSortField: SortField = .name
    @Published var ascending: Bool = false
    
    private let manager = CoreDataManager()
    
    init() {
        /*
         // LOAD FROM JSON FILES
         if let data = FileLoader.readLocalFile("BeersData")
         { brands = FileLoader.loadJson(data) }
         brands = getAll()
        */
        
        // LOAD FROM CORE DATA
        fetchAll()
    }
    
    
    func fetchAll() {
        brands.removeAll()
        let brandsE = manager.fetchBrands()
        for brandE in brandsE {
            var newBrand = Brand(title: brandE.title!, image: brandE.image!, type: brandE.type!)
            let beersE = manager.fetchBeers(brandE)
            for beerE in beersE {
                let newBeer = Beer(title: beerE.title!, image: beerE.image!, type: beerE.type!, grades: beerE.grades, cal: beerE.cal)
                newBrand.beers.insert(newBeer, at: 0)
            }
            brands.insert(newBrand, at: 0)
        }
    }
    
    func saveBrand() {
        /*
        let newBrand = Brand(title: title, image: selectedImageData!, type: type.rawValue)
        brands.insert(newBrand, at: 0)
        */
        
        manager.createBrand(title: title, type: type.rawValue, image: selectedImageData!) { [weak self] in self?.fetchAll() }
    }
    
    func saveBeer(withId id: String) {
        guard let gradesDouble = grades.toDouble() else {return}
        guard let calDouble = cal.toDouble() else {return}
        
        /*
        let newBeer = Beer(title: title, image: selectedImageData!, type: typeBeer.rawValue, grades: gradesDouble, cal: calDouble)
        }
        */
        
        guard let i = brands.firstIndex(where: { $0.id == id }) else {return}
        manager.createBeer(title: title, type: typeBeer.rawValue, image: selectedImageData!, grades: gradesDouble, cal: calDouble, index: i) { [weak self] in self?.fetchAll() }
    }
    
    func removeBrand(withId id: String) {
        brands.removeAll(where: { $0.id == id })
    }
    
    func removeBeer(withId id: String, withBrandId bid: String) {
        if let i = brands.firstIndex(where: { $0.id == bid }) {
            brands[i].beers.removeAll(where: { $0.id == id })
        }
    }
    
    func sort(withId id: String) {
        if let i = brands.firstIndex(where: { $0.id == id }) {
            switch selectedSortField {
            case .name: brands[i].beers.sort { ascending ? $0.title < $1.title : $0.title > $1.title }
            case .grades: brands[i].beers.sort { ascending ? $0.grades < $1.grades : $0.grades > $1.grades }
            case .calories: brands[i].beers.sort { ascending ? $0.cal < $1.cal : $0.cal > $1.cal }
            }
        }
    }
    
    func favoriteBeer(beer: Binding<Beer>) {
        if beer.wrappedValue.isFavorited {
            favorites.insert(beer.wrappedValue, at: 0)
        } else {
            favorites.removeAll(where: { $0.id == beer.wrappedValue.id })
        }
        beer.wrappedValue.isFavorited = !beer.wrappedValue.isFavorited
    }
    
    //JSON ENCODING IN USER DEFAULTS
    private func encodeAll() {
        if let encoded = try? JSONEncoder().encode(brands) {
            UserDefaults.standard.setValue(encoded, forKey: "brands")
            UserDefaults.standard.synchronize()
            //FileLoader.saveDataToDocuments(encoded)
        }
    }
    
    func getAll() -> [Brand] {
        if let brandsData = UserDefaults.standard.object(forKey: "brands") as? Data {
            if let brands = try? JSONDecoder().decode([Brand].self, from: brandsData) {
                return brands
            }
        }
        return []
    }
}

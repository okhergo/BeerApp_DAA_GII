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
    case lager, pilsen, negra, mixta
    var id: String { self.rawValue }
}

extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        let number = formatter.number(from: self)
        
        return number as? Double
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
    
    private let manager = CoreDataManager.shared
    
    init() {
        /*
         // LOAD FROM JSON FILES
         if let data = FileLoader.readLocalFile("BeersData")
         { brands = FileLoader.loadJson(data) }
         brands = getAll()
        */
        favorites = getAllFavs()
        
        // LOAD FROM CORE DATA
        fetchAll()
    }
    
    func fetchAll() {
        brands.removeAll()
        let brandsE = manager.fetchBrands()
        var i = 0
        for brandE in brandsE {
            var newBrand = Brand(id: brandE.id!, title: brandE.title!, image: brandE.image!, type: brandE.type!)
            let beersE = manager.fetchBeers(brandE)
            var j = 0
            for beerE in beersE {
                let newBeer = Beer(id: beerE.id!, title: beerE.title!, image: beerE.image!, type: beerE.type!, grades: beerE.grades, cal: beerE.cal)
                newBrand.beers.insert(newBeer, at: j)
                j+=1
            }
            brands.insert(newBrand, at: i)
            i+=1
        }
    }
    
    func saveBrand() {
        /*
        let newBrand = Brand(title: title, image: selectedImageData!, type: type.rawValue)
        brands.insert(newBrand, at: 0)
        */
        
        manager.createBrand(title: title, type: type.rawValue, image: selectedImageData!) { [weak self] in self?.fetchAll() }
    }
    
    func saveBeer(withId id: String) -> String {
        guard let gradesDouble = grades.toDouble() else {return String(localized: "NumberError")}
        guard let calDouble = cal.toDouble() else {return String(localized: "NumberError")}
        
        /*
        let newBeer = Beer(title: title, image: selectedImageData!, type: typeBeer.rawValue, grades: gradesDouble, cal: calDouble)
        }
        */
        
        guard let i = brands.firstIndex(where: { $0.id == id }) else {return String(localized: "UnableToSave")}
        manager.createBeer(title: title, type: typeBeer.rawValue, image: selectedImageData!, grades: gradesDouble, cal: calDouble, index: i) { [weak self] in self?.fetchAll() }
        return ""
    }
    
    func removeBrand(withId id: String) {
        //brands.removeAll(where: { $0.id == id })
        
        manager.deleteBrand(withId: id) { [weak self] in self?.fetchAll() }
    }
    
    func removeBeer(withId id: String, withBrandId bid: String) {
        manager.deleteBeer(withId: id, withBrandId: bid) { [weak self] in self?.fetchAll() }
        //brands[i].beers.removeAll(where: { $0.id == id })
        
        favorites.removeAll(where: { $0.id == id })
        encodeFav()
    }

    func sort(withId id: String) {
        if let i = brands.firstIndex(where: { $0.id == id }) {
            switch selectedSortField {
            case .name: brands[i].beers.sort { $0.title < $1.title }
            case .grades: brands[i].beers.sort { $0.grades > $1.grades }
            case .calories: brands[i].beers.sort { $0.cal > $1.cal }
            }
        }
    }
    
    func favoriteBeer(beer: Binding<Beer>) {
        if favorites.firstIndex(where: { $0.id == beer.id }) == nil {
            favorites.insert(beer.wrappedValue, at: 0)
        } else {
            favorites.removeAll(where: { $0.id == beer.id })
        }
        encodeFav()
    }
    
    private func encodeFav() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.setValue(encoded, forKey: "favorites")
            UserDefaults.standard.synchronize()
            //FileLoader.saveDataToDocuments(encoded)
        }
    }
    
    func getAllFavs() -> [Beer] {
        if let favsData = UserDefaults.standard.object(forKey: "favorites") as? Data {
            if let favs = try? JSONDecoder().decode([Beer].self, from: favsData) {
                return favs
            }
        }
        return []
    }
    
    //JSON ENCODING BRANDS IN USER DEFAULTS
    /*
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
     */
}

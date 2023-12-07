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

final class ViewModel: ObservableObject {
    @Published var brands: [Model] = []
    @Published var favorites: [BeerModel] = []
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    @Published var type: BrandType = .nacionales
    @Published var title: String = ""
    
    init() {
        brands = getAll()
    }
    
    func saveBrand() {
        let newBrand = Model(title: title, image: selectedImageData!, type: type.rawValue)
        brands.insert(newBrand, at: 0)
    }
    
    func saveBeer(withId id: String) {
        let newBeer = BeerModel(title: title, image: selectedImageData!, type: type.rawValue)
        if let i = brands.firstIndex(where: { $0.id == id }) {
            brands[i].beers.insert(newBeer, at: 0)
        }
    }
    
    private func encodeAll() {
        if let encoded = try? JSONEncoder().encode(brands) {
            UserDefaults.standard.setValue(encoded, forKey: "brands")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAll() -> [Model] {
        if let brandsData = UserDefaults.standard.object(forKey: "brands") as? Data {
            if let brands = try? JSONDecoder().decode([Model].self, from: brandsData) {
                return brands
            }
        }
        return []
    }
    
    func removeBrand(withId id: String) {
        brands.removeAll(where: { $0.id == id })
        encodeAll()
    }
    
    func removeBeer(withId id: String, withBrandId bid: String) {
        if let i = brands.firstIndex(where: { $0.id == bid }) {
            brands[i].beers.removeAll(where: { $0.id == id })
        }
        encodeAll()
    }
    
    func favoriteBeer(beer: Binding<BeerModel>) {
        beer.wrappedValue.isFavorited = !beer.wrappedValue.isFavorited
        encodeAll()
    }
}

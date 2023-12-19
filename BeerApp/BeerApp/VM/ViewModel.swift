//
//  ViewModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

//Enumeración con los tipos de marcas
enum BrandType: String, CaseIterable, Identifiable {
    case nacionales, importadas
    var id: String { self.rawValue }
}

//Enumeración con los tipos de cervezas
enum BeerType: String, CaseIterable, Identifiable {
    case lager, pilsen, negra, mixta
    var id: String { self.rawValue }
}

//Enumeración con los campos por los que poder ordenar
enum SortField: String, CaseIterable {
    case name, grades, calories
}

final class ViewModel: ObservableObject {
    //Colecciones de marcas y de cervezas favoritas
    @Published var brands: [Brand] = []
    @Published var favorites: [Beer] = []
    
    //Variables de inserción de datos
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    @Published var type: BrandType = .nacionales
    @Published var typeBeer: BeerType = .lager
    @Published var title: String = ""
    @Published var grades: String = ""
    @Published var cal: String = ""
    
    @Published var selectedSortField: SortField = .name
    @Published var ascending: Bool = false
    
    //Instancia singleton del modelo con acceso a CoreData
    private let manager = CoreDataManager.shared
    
    init() {
        favorites = getAllFavs()
        fetchAll()
    }
    
    /*
     Índice:
     1. FetchAll: Cargar todos los datos
     2. Crear: Brand, Beer
     3. Eliminar: Brand, Beer
     4. Ordenación: sort
     5. Favoritas: favoriteBeer, encodeFav, getAllFavs
     */
    
    //FUNCIÓN DE CARGA DE DATOS
    //Función para cargar todos los datos de marcas y cervezas
    func fetchAll() {
        brands.removeAll()
        
        //Obtiene las marcas desde el CoreData
        let brandsE = manager.fetchBrands()
        
        var i = 0
        for brandE in brandsE {
            //Transforma al modelo propio Brand
            var newBrand = Brand(id: brandE.id!, title: brandE.title!, image: brandE.image!, type: brandE.type!)
            
            //Obtiene las cervezas de la marca desde el CoreData
            let beersE = manager.fetchBeers(brandE)
            
            var j = 0
            for beerE in beersE {
                //Transforma al modelo propio Beer
                let newBeer = Beer(id: beerE.id!, title: beerE.title!, image: beerE.image!, type: beerE.type!, grades: beerE.grades, cal: beerE.cal)
                
                //Inserta en la colección de cervezas de la marca
                newBrand.beers.insert(newBeer, at: j)
                j+=1
            }
            //Inserta en el array de cervezas en la posición correspondiente
            brands.insert(newBrand, at: i)
            i+=1
        }
    }
    
    //FUNCIONES DE CREACIÓN
    func saveBrand() {
        //Crear una marca y actualiza las colecciones con fetchAll
        manager.createBrand(title: title, type: type.rawValue, image: selectedImageData!) { [weak self] in self?.fetchAll() }
    }
    
    func saveBeer(withId id: String) -> String {
        //Transforma a double la graduación y las calorías
        guard let gradesDouble = grades.toDouble() else {return String(localized: "NumberError")}
        guard let calDouble = cal.toDouble() else {return String(localized: "NumberError")}
        
        //Crea la cerveza y actualiza las colecciones con fetchAll
        manager.createBeer(title: title, type: typeBeer.rawValue, image: selectedImageData!, grades: gradesDouble, cal: calDouble, id: id) { [weak self] in self?.fetchAll() }
        
        //Devuelve una cadena vacía si no hubo errores
        return ""
    }
    
    //FUNCIONES DE ELIMINACIÓN
    func removeBrand(withId id: String) {
        //Elimina una marca y actualiza las colecciones con fetchAll
        manager.deleteBrand(withId: id) { [weak self] in self?.fetchAll() }
    }
    
    func removeBeer(withId id: String, withBrandId bid: String) {
        //Elimina una cerveza y actualiza las colecciones con fetchAll
        manager.deleteBeer(withId: id, withBrandId: bid) { [weak self] in self?.fetchAll() }
        
        //Si era favorita, la elimina y actualiza la colección de favoritas
        favorites.removeAll(where: { $0.id == id })
        encodeFav()
    }

    //FUNCIÓN DE ORDENACIÓN
    func sort(withId id: String) {
        if let i = brands.firstIndex(where: { $0.id == id }) {
            //Obtiene la marca y ordena sus cervezas según el campo seleccionado
            switch selectedSortField {
            case .name: brands[i].beers.sort { $0.title < $1.title }
            case .grades: brands[i].beers.sort { $0.grades > $1.grades }
            case .calories: brands[i].beers.sort { $0.cal > $1.cal }
            }
        }
    }
    
    //FUNCIONES DE GESTIÓN DE CERVEZAS FAVORITAS
    func favoriteBeer(beer: Binding<Beer>) {
        //Inserta o elimina del array de favoritas según si ya estaban o no
        if let i = favorites.firstIndex(where: { $0.id == beer.id }) {
            favorites.remove(at: i)
        } else {
            favorites.insert(beer.wrappedValue, at: 0)
        }
        encodeFav()
    }
    
    //Guarda las favoritas en UserDefaults
    private func encodeFav() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.setValue(encoded, forKey: "favorites")
            UserDefaults.standard.synchronize()
        }
    }
    
    //Obtiene las favoritas de UserDefaults
    func getAllFavs() -> [Beer] {
        if let favsData = UserDefaults.standard.object(forKey: "favorites") as? Data {
            if let favs = try? JSONDecoder().decode([Beer].self, from: favsData) {
                return favs
            }
        }
        return []
    }
    
    /*
     Para utilizar ficheros .json en lugar de CoreData:
     
     init(){
        if let data = FileLoader.readLocalFile("BeersData"){
            brands = FileLoader.loadJson(data) }
        brands = getAll()
     }
     
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

//Función para convertir una cadena a número
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

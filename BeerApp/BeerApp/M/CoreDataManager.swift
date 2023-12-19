//
//  CoreDataManager.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import Foundation
import CoreData

class CoreDataManager {
    private let container : NSPersistentContainer!
    
    //Patrón singleton para tener una única instancia del acceso al CoreData
    static var shared: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()
    
    private init() {
        container = NSPersistentContainer(name: "Banking")
        setupDatabase()
    }
    
    //Función que carga los datos almacenados en un contenedor
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    /*
     Índice:
     1. Creación: User, Brand, Beer, Review
     2. Eliminación: Brand, Brand, Review
     3. Obtención: Users, Brands, Beer, AllBeers, Reviews
     */
    
    //FUNCIONES DE CREACIÓN DE OBJETOS
    func createUser(username : String, password : String, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let user = UserE(context: context)
        user.username = username
        user.password = password
        
        //Guarda los datos en el CoreData
        do {
            try context.save()
            completion()
        } catch {
            print("Error saving user — \(error)")
        }
    }
    
    func createBrand(title : String, type : String, image : Data, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let brand = BrandE(context: context)
        brand.id = UUID().uuidString
        brand.title = title
        brand.type = type
        brand.image = image

        do {
            try context.save()
            completion()
        } catch {
            print("Error saving brand — \(error)")
        }
    }
    
    func createBeer(title: String, type: String, image: Data, grades: Double, cal: Double, id: String, completion: @escaping() -> Void) {
        let context = container.viewContext
        let brands = fetchBrands()
        
        let newBeer = BeerE(context: context)
        newBeer.id = UUID().uuidString
        newBeer.title = title
        newBeer.type = type
        newBeer.image = image
        newBeer.grades = grades
        newBeer.cal = cal
        
        guard let index = brands.firstIndex(where: { $0.id == id }) else { return }
        newBeer.brand = brands[index]
        
        do {
        try context.save()
            completion()
        } catch {
            print("Error saving brand — \(error)")
        }
    }
    
    func createReview(beerId : String, caption : String, points : Int, image : Data?, user: UserE, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let beers = fetchAllBeers()
        let beer = beers.first(where: {$0.id == beerId})
        
        let review = ReviewE(context: context)
        review.id = UUID().uuidString
        review.caption = caption
        review.points = Int16(points)
        review.image = image
        review.user = user
        review.beer = beer

        do {
            try context.save()
            completion()
        } catch {
            print("Error saving brand — \(error)")
        }
    }
    
    //FUNCIONES DE ELIMINACIÓN DE OBJETOS
    func deleteBrand(withId id: String, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let brands = fetchBrands()
        
        //Busca el índice en el que se encuentra la marca dentro del array
        guard let i = brands.firstIndex(where: { $0.id == id }) else {return}
        context.delete(brands[i])
        
        do {
        try context.save()
            completion()
        } catch {
            print("Error deleting brand — \(error)")
        }
    }
    
    func deleteBeer(withId id: String, withBrandId bid: String, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let brands = fetchBrands()
        
        guard let brandIndex = brands.firstIndex(where: { $0.id == bid }) else { return }
        
        let beers = fetchBeers(brands[brandIndex])
        
        guard let i = beers.firstIndex(where: { $0.id == id }) else { return }
        context.delete(beers[i])
        
        do {
        try context.save()
            completion()
        } catch {
            print("Error deleting brand — \(error)")
        }
    }
    
    func deleteReview(withId id: String, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let reviews = fetchReviews()
        guard let i = reviews.firstIndex(where: { $0.id == id }) else {return}
        context.delete(reviews[i])
        
        do {
        try context.save()
            completion()
        } catch {
            print("Error deleting brand — \(error)")
        }
    }
    
    //FUNCIONES DE OBTENCIÓN DE LAS COLECCIONES DE OBJETOS
    func fetchUsers() -> [UserE] {
        //Solicitud de todos los objetos de la clase UserE
        let fetchRequest : NSFetchRequest<UserE> = UserE.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
    
    func fetchBrands() -> [BrandE] {
        let fetchRequest : NSFetchRequest<BrandE> = BrandE.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
    
    //Función para obtener las cervezas de una marca
    func fetchBeers(_ brand: BrandE) -> [BeerE] {
        let fetchRequest : NSFetchRequest<BeerE> = BeerE.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest).filter({$0.brand == brand})
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
    
    //Función para obtener todas las cervezas
    func fetchAllBeers() -> [BeerE] {
        let fetchRequest : NSFetchRequest<BeerE> = BeerE.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
    
    func fetchReviews() -> [ReviewE] {
        let fetchRequest : NSFetchRequest<ReviewE> = ReviewE.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
}

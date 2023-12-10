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
    
    init() {
        container = NSPersistentContainer(name: "Banking")
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
        
    func createUser(username : String, password : String, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let user = UserE(context: context)
        user.username = username
        user.password = password
        
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
        
    func createBeer(title: String, type: String, image: Data, grades: Double, cal: Double, index: Int, completion: @escaping() -> Void) {
        let context = container.viewContext
        guard let brand = retrieveBrand(index) else { return }
        
        let newBeer = BeerE(context: context)
        newBeer.id = UUID().uuidString
        newBeer.title = title
        newBeer.type = type
        newBeer.image = image
        newBeer.grades = grades
        newBeer.cal = cal
        
        newBeer.brand = brand
        
        do {
        try context.save()
            completion()
        } catch {
            print("Error saving brand — \(error)")
        }
    }
    
    func retrieveBrand(_ index: Int) -> BrandE? {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BrandE")
        
        do {
            let result = try context.fetch(fetchRequest) as! [BrandE]
            if result.count > 0 {
                return result[index]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Retrieving brand failed. \(error)")
            return nil
        }
    }

    func fetchUsers() -> [UserE] {
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
}

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
        
        let user = User(context: context)
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
        
        let brand = Brand(context: context)
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
    
    func fetchUsers() -> [User] {
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
    
    func fetchBrands() -> [Brand] {
        let fetchRequest : NSFetchRequest<Brand> = Brand.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error returning user — \(error)")
        }
        return []
    }
}

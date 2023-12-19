//
//  AppDelegate.swift
//  BeerApp
//
//  Created by Óscar Khergo on 11/12/23.
//

import Foundation
import UIKit
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //Función que se ejecuta al iniciarse la aplicación
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        
        //Carga isPreloaded de UserDefaults que indica false si es la primera vez que se inicia la app
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        
        //En caso de ser false, precarga los datos iniciales y modifica isPreloaded a true
        if !isPreloaded {
            print("Preloading data for the first time")
            preloadData()
            defaults.set(true, forKey: "isPreloaded")
        }
        return true
    }
    
    //Función que carga los datos iniciales del Bundle del proyecto en CoreData
    func preloadData() {
        //Obtiene las rutas de origen de los archivos en el Bundle
        let sourceSqliteURLs = [Bundle.main.url(forResource: "Banking", withExtension: "sqlite"), Bundle.main.url(forResource: "Banking", withExtension: "sqlite-wal"), Bundle.main.url(forResource: "Banking", withExtension: "sqlite-shm")]
        
        //Obtiene las rutas de destino del CoreData
        let destSqliteURLs = [
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Banking.sqlite"),
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Banking.sqlite-wal"),
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Banking.sqlite-shm")]
        
        //Copia todos los items
        for index in 0...sourceSqliteURLs.count-1 {
            do {
                try FileManager.default.copyItem(at: sourceSqliteURLs[index]!, to: destSqliteURLs[index])
            } catch {
                print("Could not preload data")
            }
        }
    }
}

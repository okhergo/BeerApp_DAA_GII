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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            print("Preloading data for the first time")
            preloadData()
            defaults.set(true, forKey: "isPreloaded")
        }
        return true
    }
    
    func preloadData() {
    let sourceSqliteURLs = [Bundle.main.url(forResource: "DataModel", withExtension: "sqlite"), Bundle.main.url(forResource: "DataModel", withExtension: "sqlite-wal"), Bundle.main.url(forResource: "DataModel", withExtension: "sqlite-shm")]

        let destSqliteURLs = [
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/DataModel.sqlite"),
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/DataModel.sqlite-wal"),
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/DataModel.sqlite-shm")]

        for index in 0...sourceSqliteURLs.count-1 {
            do {
                try FileManager.default.copyItem(at: sourceSqliteURLs[index]!, to: destSqliteURLs[index])
            } catch {
                print("Could not preload data")
            }
        }
    }
}

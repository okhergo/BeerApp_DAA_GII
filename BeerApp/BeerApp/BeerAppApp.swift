//
//  BeerAppApp.swift
//  BeerApp
//
//  Created by Óscar Khergo on 1/12/23.
//

import SwiftUI

@main
struct BeerAppApp: App {
    
    //Delegado que gestiona el arranque de la aplicación
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

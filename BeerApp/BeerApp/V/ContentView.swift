//
//  ContentView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 1/12/23.
//

import SwiftUI

private enum Tab: Hashable {
    case home
    case list
    case user
}

struct ContentView: View {
    @StateObject var userVM = UserViewModel()
    @StateObject var vm = ViewModel()
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tag(Tab.home)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(String(localized: "Home"))}
                
            ListView().tag(Tab.list)
                .tabItem {
                    Image(systemName: "square.stack")
                    Text(String(localized: "BeerList"))}
            
            //Muestra la pantalla de login o la de usuario en función de si ya ha iniciado sesión o no
            Group {
                if !userVM.isLoggedIn {
                    LoginView().tag(Tab.user)
                } else {
                    UserView().tag(Tab.user)
                }
            }.tabItem {
                Image(systemName: "person.circle")
                Text(String(localized: "User"))}
        }
        //Establece las variables del ViewModel y UserViewModel visibles en todas las interfaces, para mantener siempre la misma instancia.
        .environmentObject(vm)
        .environmentObject(userVM)
        .id(selectedTab)
        .onAppear(){
            //Estilo de TabBar personalizado
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            
            UITabBar.appearance().backgroundColor = .systemGray6
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    ContentView()
}

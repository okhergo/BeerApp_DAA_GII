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
                
            Group {
                if !userVM.isLoggedIn {
                    LoginView(userVM: userVM).tag(Tab.user)
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text(String(localized: "User"))}
                } else {
                    UserView().tag(Tab.user)
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text(String(localized: "User"))}
                }
            }
        }
        .environmentObject(vm)
        .id(selectedTab)
        .onAppear(){
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

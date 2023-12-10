//
//  UserView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var userVM: UserViewModel
    private var username: String
    
    init(userVM: UserViewModel) {
        self.userVM = userVM
        username = userVM.userLogged!.username!
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Text(String(localized: "Developer"))
            }
            .navigationTitle(String(localized: "Welcome") + username)
        }
    }
}

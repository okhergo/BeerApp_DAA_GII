//
//  UserView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var userVM: UserViewModel
    var body: some View {
        NavigationView {
            VStack{
                Text(String(localized: "Welcome") + "\(userVM.userLogged!.username)")
            }
            .navigationTitle(String(localized: "UserTitle"))
        }
    }
}

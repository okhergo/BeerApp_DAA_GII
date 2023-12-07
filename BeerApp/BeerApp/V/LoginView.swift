//
//  LoginView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI
import AuthenticationServices

enum Field: Hashable {
    case usernameField
    case passwordField
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    @State private var error: String = ""
    
    @ObservedObject var userVM: UserViewModel
    
    fileprivate func LoginButton() -> some View {
        Button(String(localized: "LoginButton")) {
            if username.isEmpty {
                focusedField = .usernameField
            }
            if password.isEmpty {
                focusedField = .passwordField
            }
            if userVM.signIn(username: username, password: password) == false {
                error = "Los datos introducidos son erroneos"
            }
            else {
                error = ""
            }
        }
        .buttonStyle(.bordered)
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack{
                    TextField("Username", text: $username)
                        .focused($focusedField, equals: .usernameField)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 20)
                    SecureField("Password", text: $password)
                        .focused($focusedField, equals: .passwordField)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 20)
                LoginButton()
                Text(error)
            }
            .navigationTitle(String(localized: "LoginTitle"))
        }
    }
}

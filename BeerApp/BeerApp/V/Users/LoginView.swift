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
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        if(userVM.isBusy){
            ProgressView().progressViewStyle(.circular)
        } else {
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
                    HStack{
                        LoginButton()
                        SignInButton()
                    }
                    Text(error)
                }
                .navigationTitle(String(localized: "LoginTitle"))
            }
        }
    }
    
    //BOTONES DE ESTILO PERSONALIZADO
    fileprivate func LoginButton() -> some View {
        Button(String(localized: "LoginButton")) {
            if username.isEmpty {
                focusedField = .usernameField
            }
            if password.isEmpty {
                focusedField = .passwordField
            }
            if !userVM.signIn(username: username, password: password) {
                error = String(localized: "InvalidData")
            }
            else {
                error = ""
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    fileprivate func SignInButton() -> some View {
        Button(String(localized: "SignInButton")) {
            if username.isEmpty {
                focusedField = .usernameField
            }
            if password.isEmpty {
                focusedField = .passwordField
            }
            if !userVM.addUser(username: username, password: password) {
                error = String(localized: "AccountExists")
            }
            else {
                error = ""
            }
        }
        .buttonStyle(.bordered)
        .padding()
    }
    
}

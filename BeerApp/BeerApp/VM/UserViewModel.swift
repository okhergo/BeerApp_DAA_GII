//
//  UserViewModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation

final class UserViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isBusy = false
    @Published var users: [UserModel] = []
    
    @Published var userLogged: UserModel?
    
    init() {
        users = getAllUsers()
    }
    
    func addUser(username: String, password: String) {
        let newUser = UserModel(username: username, password: password)
        users.insert(newUser, at: 0)
        encodeAndSaveAllUsers()
        if !signIn(username: username, password: password) { return }
    }
    
    private func encodeAndSaveAllUsers() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.setValue(encoded, forKey: "users")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAllUsers() -> [UserModel] {
        if let usersData = UserDefaults.standard.object(forKey: "users") as? Data {
            if let users = try? JSONDecoder().decode([UserModel].self, from: usersData) {
                return users
            }
        }
        return []
    }
    
    func signIn(username: String, password: String) -> Bool {
        var flag: Bool = false
        for user in users {
            if username == user.username && password == user.password {
                isLoggedIn = true
                isBusy = false
                flag = true
                userLogged = user
            }
        }
        isBusy = false
        return flag
    }
    
}

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
    @Published var users: [UserE] = []
    
    @Published var userLogged: UserE?
    
    private let manager = CoreDataManager()
    
    init() {
        fetchUsers()
    }
    
    
    func fetchUsers() {
        users = manager.fetchUsers()
    }
    
    func addUser(username: String, password: String) {
        isBusy = true
        manager.createUser(username: username, password: password) { [weak self] in self?.fetchUsers() }
        
        if !signIn(username: username, password: password) { return }
    }
    
    func signIn(username: String, password: String) -> Bool {
        var flag: Bool = false
        isBusy = true
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

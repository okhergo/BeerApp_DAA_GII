//
//  UserModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation

struct User: Codable{
    let id: String
    var username: String
    var password: String
    var specialUser: Bool
    
    init(id: String = UUID().uuidString, username: String, password: String, specialUser: Bool = false) {
        self.id = id
        self.username = username
        self.password = password
        self.specialUser = specialUser
    }
}

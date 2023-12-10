//
//  Model.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation

struct Brand: Codable, Identifiable {
    let id: String
    let title: String
    let image: Data
    let type: String
    var beers: [Beer] = []
    
    init(id: String, title: String, image: Data, type: String) {
        self.id = id
        self.title = title
        self.image = image
        self.type = type
    }
}

class Model: ObservableObject{
    @Published var brands: [Brand] = []
    @Published var favorites: [Beer] = []
}

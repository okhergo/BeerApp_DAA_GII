//
//  Model.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation

struct Model: Codable, Identifiable {
    let id: String
    var isFavorited: Bool
    let title: String
    let image: String
    let caption: String
    
    init(id: String = UUID().uuidString, isFavorited: Bool = false, title: String, image: String, caption: String) {
        self.id = id
        self.isFavorited = isFavorited
        self.title = title
        self.image = image
        self.caption = caption
    }
}

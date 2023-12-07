//
//  BeerModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 7/12/23.
//

import Foundation

struct BeerModel: Codable, Identifiable {
    let id: String
    var isFavorited: Bool
    let title: String
    let image: Data
    let type: String
    
    init(id: String = UUID().uuidString, isFavorited: Bool = false, title: String, image: Data, type: String) {
        self.id = id
        self.isFavorited = isFavorited
        self.title = title
        self.image = image
        self.type = type
    }
}

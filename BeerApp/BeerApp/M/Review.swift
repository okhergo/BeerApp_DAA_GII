//
//  Review.swift
//  BeerApp
//
//  Created by Óscar Khergo on 14/12/23.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let title: String
    let image: Data
    let description: String
    let points: Int
    
    init(id: String, title: String, image: Data, description: String, points: Int) {
        self.id = id
        self.title = title
        self.image = image
        self.description = description
        self.points = points
    }
}

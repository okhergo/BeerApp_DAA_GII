//
//  UserViewModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

enum ReviewSortField: String, CaseIterable {
    case name, points
}

final class UserViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isBusy = false
    @Published var users: [UserE] = []
    @Published var reviews: [ReviewE] = []
    @Published var selectedSortField: ReviewSortField = .name
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    @Published var beerId: String = ""
    @Published var points: Int = 0
    @Published var caption: String = ""
    
    @Published var userLogged: UserE?
    
    private let manager = CoreDataManager.shared
    
    init() {
        fetchUsers()
    }
    
    func fetchReviews() {
        reviews.removeAll()
        let reviewsE = manager.fetchReviews()
        reviews = reviewsE
    }
    
    func fetchUsers() {
        users = manager.fetchUsers()
    }
    
    func addUser(username: String, password: String) {
        isBusy = true
        if((users.first(where: {$0.username == username})) == nil){
            manager.createUser(username: username, password: password) { [weak self] in self?.fetchUsers() }
        }
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
                fetchReviews()
            }
        }
        isBusy = false
        return flag
    }
    
    func saveReview() {
        manager.createReview(beerId: beerId, caption: caption, points: points, image: selectedImageData, user: userLogged!) { [weak self] in self?.fetchReviews() }
    }
    
    func removeReview(withId id: String) {
        manager.deleteReview(withId: id) { [weak self] in self?.fetchReviews() }
    }

    func sort(withId id: String) {
        switch selectedSortField {
        case .name: reviews.sort { $0.title! < $1.title! }
        case .points: reviews.sort { $0.points > $1.points }
        }
    }
}

//
//  UserViewModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation
import SwiftUI
import PhotosUI

//Enumeración con los campos por los que poder ordenar
enum ReviewSortField: String, CaseIterable {
    case name, points
}

final class UserViewModel: ObservableObject {
    //Colecciones de usuarios y reseñas
    @Published var users: [UserE] = []
    @Published var reviews: [ReviewE] = []
    
    //Usuario que ha iniciado sesión
    @Published var userLogged: UserE?
    
    @Published var isLoggedIn = false
    @Published var isBusy = false
    
    //Variables de inserción de datos
    @Published var selectedSortField: ReviewSortField = .name
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    @Published var beerId: String = ""
    @Published var points: Int = 1
    @Published var caption: String = ""
    
    //Instancia singleton del modelo con acceso a CoreData
    private let manager = CoreDataManager.shared
    
    init() {
        fetchUsers()
    }
    
    /*
     Índice:
     1. Cargar: fetchReviews, fetchUsers
     2. Inicio de sesión: addUser, signIn
     3. Reseñas: saveReview, deleteReview, sort
     */
    
    //FUNCIÓN DE CARGA DE DATOS
    //Función para cargar las reseñas
    func fetchReviews() {
        reviews.removeAll()
        let reviewsE = manager.fetchReviews()
        reviews = reviewsE
    }
    
    //Función para cargar los usuarios
    func fetchUsers() {
        users = manager.fetchUsers()
    }
    
    //FUNCIONES DE INICIO DE SESIÓN
    //Función de creación de un nuevo usuario
    func addUser(username: String, password: String) -> Bool {
        isBusy = true
        //Comprobación de que no exista un usario con el mismo nombre
        if((users.first(where: {$0.username == username})) == nil){
            //Creación y almacenamiento de la entidad en CoreData
            manager.createUser(username: username, password: password) { [weak self] in self?.fetchUsers() }
            //Inicia sesión con el usuario tras haber sido creada la cuenta
            if !signIn(username: username, password: password) { return false }
            return true
        }
        //Devuelve un boolean indicando si se ha realizado satisfactoriamente o no
        return false
    }
    
    //Función de incio de sesión
    func signIn(username: String, password: String) -> Bool {
        var flag: Bool = false
        isBusy = true
        for user in users {
            if username == user.username && password == user.password {
                isLoggedIn = true
                isBusy = false
                flag = true
                userLogged = user
                //Carga las reseñas del usuario
                fetchReviews()
            }
        }
        isBusy = false
        return flag
    }
    
    //FUNCIONES DE RESEÑAS
    //Guardar reseña
    func saveReview() {
        manager.createReview(beerId: beerId, caption: caption, points: points, image: selectedImageData, user: userLogged!) { [weak self] in self?.fetchReviews() }
    }
    
    //Eliminar reseña
    func removeReview(withId id: String) {
        manager.deleteReview(withId: id) { [weak self] in self?.fetchReviews() }
    }

    //Ordenar reseña
    func sort(withId id: String) {
        switch selectedSortField {
        case .name: reviews.sort { $0.title! < $1.title! }
        case .points: reviews.sort { $0.points > $1.points }
        }
    }
}

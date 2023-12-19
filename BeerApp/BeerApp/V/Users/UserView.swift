//
//  UserView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                //Listado de las reseñas del usuario
                List{
                    Section{
                        ForEach($userVM.reviews, id: \.id) { $review in
                            ReviewItem(review: $review)
                        }
                    } header: {
                        Text(String(localized: "Reviews"))
                            .frame(height: 50)
                    }
                    .headerProminence(.increased)
                }
                
                //Botón para añadir nuevas reseñas
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text(String(localized:"AddNewReview"))
                })
                .sheet(isPresented: $isPresented, content: { AddReviewView(dismissSheet: $isPresented)
                })
                .padding()
            }
            .navigationTitle(String(localized: "Welcome") + userVM.userLogged!.username!)
        }
    }
}

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
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text(String(localized:"AddNewReview"))
                })
                .sheet(isPresented: $isPresented, content: { AddReviewView(dismissSheet: $isPresented, userVM: userVM)
                })
                .padding()
            }
            .navigationTitle(String(localized: "Welcome") + userVM.userLogged!.username!)
        }
    }
}

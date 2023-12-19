//
//  ReviewItem.swift
//  BeerApp
//
//  Created by Óscar Khergo on 14/12/23.
//

import SwiftUI

struct ReviewItem: View {
    @Binding var review: ReviewE
    @EnvironmentObject var userVM: UserViewModel
    @State var isPresented: Bool = false
    
    var body: some View{
        if(($userVM.reviews.first(where: {$0.id == review.id})) != nil){
            NavigationLink {
                ReviewDetailView(review: $review)
            } label: {
                VStack (alignment: .leading, spacing: 10){
                    if(review.beer != nil){
                        Text(review.beer!.brand!.title! + " " + review.beer!.title!)
                    }
                    HStack{
                        ForEach((1...review.points) , id: \.self) {_ in
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }
                        if(review.points < 5){
                            ForEach((review.points...4) , id: \.self) {_ in
                                Image(systemName: "star.fill").foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
                .swipeActions(edge: .leading) {
                    Button {
                        userVM.removeReview(withId: review.id!)
                    } label : {
                        Label(String(localized: "Trash"), systemImage: "trash.fill")
                    }
                    .tint(.red)
                }
            }
        }
    }
}

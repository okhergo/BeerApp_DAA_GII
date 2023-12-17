//
//  ReviewDetailView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 14/12/23.
//

import SwiftUI

struct ReviewDetailView: View {
    @Binding var review: ReviewE
    @State private var isEditPresented = false
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View{
        if(($userVM.reviews.first(where: {$0.id == review.id})) != nil){
            NavigationStack {
                Text(review.beer!.title!).font(.title).bold()
                HStack{
                    ForEach((1...review.points) , id: \.self) {_ in
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                    }
                    if(review.points < 5){
                        ForEach((review.points...4) , id: \.self) {_ in
                            Image(systemName: "star.fill").foregroundColor(.gray)
                        }
                    }
                }.padding()
                Text(review.caption!)
                if((review.image) != nil){
                    Image(uiImage: UIImage(data:review.image!)!)
                        .resizable().scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
                Spacer()
                Button(action: {
                    isEditPresented.toggle()
                }, label: {
                    Label(String(localized: "Edit"), systemImage: "pencil")
                })
                .sheet(isPresented: $isEditPresented, content: {
                    EditReviewView(dismissSheet: $isEditPresented, review: $review)
                })
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

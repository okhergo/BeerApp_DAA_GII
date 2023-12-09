//
//  BeerListItem.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI

struct BeerItem: View {
    @Binding var beer: BeerModel
    @Binding var brand: Model
    @EnvironmentObject var vm: ViewModel
    @State var isPresented: Bool = false
    
    var body: some View{
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack {
                Image(uiImage: UIImage(data:beer.image)!)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                    .padding()
                Text(beer.title)
                    .font(.title)
            }
            .swipeActions(edge: .trailing) {
                Button {
                    vm.favoriteBeer(beer: $beer)
                } label : {
                    Label(String(localized: "Star"), systemImage: "star.fill")
                }
                .tint(.yellow)
            }
            .swipeActions(edge: .leading) {
                Button {
                    vm.removeBeer(withId: beer.id, withBrandId: brand.id)
                } label : {
                    Label(String(localized: "Trash"), systemImage: "trash.fill")
                }
                .tint(.red)
            }
        })
        .sheet(isPresented: $isPresented, content: {
            BeerDetailView(beer: $beer, brand: $brand)
        })
    }
}

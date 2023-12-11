//
//  BeerListItem.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI

struct BeerItem: View {
    @Binding var beer: Beer
    @Binding var brand: Brand
    @EnvironmentObject var vm: ViewModel
    @State var isPresented: Bool = false
    
    var body: some View{
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack {
                Image(uiImage: UIImage(data:beer.image)!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                    .padding()
                VStack (alignment: .leading){
                    Text(beer.title)
                        .font(.title2).bold().foregroundColor(.black)
                    Text(String(format: "%.1f", beer.grades) + "% ºC | "  + String(format: "%.0f", beer.cal) + " kcal")
                        .font(.subheadline).foregroundColor(.black)
                }
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

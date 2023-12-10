//
//  SwiftUIView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI

struct BeerDetailView: View {
    @Binding var beer: Beer
    @Binding var brand: Brand
    @State private var isEditPresented = false
    @EnvironmentObject var vm: ViewModel
    
    var body: some View{
        NavigationView{
            VStack{
                HStack{
                    Image(uiImage: UIImage(data:beer.image)!)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                        .padding()
                    
                    if ($vm.favorites.first(where: { $0.id == beer.id }) != nil) {
                        Image(systemName: "star.fill")
                    }
                }
                Text(beer.type)
                Text(String(localized:"Gradation") + ": " + String(format: "%.1f", beer.grades))
                Text(String(localized: "Calories") + ": " + String(format: "%.0f", beer.cal))
                Spacer()
                Button(action: {
                    isEditPresented.toggle()
                }, label: {
                    Label(String(localized: "Edit"), systemImage: "pencil")
                })
                .sheet(isPresented: $isEditPresented, content: {
                    EditBeerView(dismissSheet: $isEditPresented, brand: $brand, beer: $beer)
                })
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle(beer.title)
        }
    }
}

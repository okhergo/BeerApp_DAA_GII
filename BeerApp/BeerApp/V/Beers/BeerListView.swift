//
//  BeerListView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI

struct BeerListView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var brand: Brand
    @State var isPresented = false
    @State var isEditPresented = false
    @State private var searchText = ""
    
    //Colección de cervezas filtrada por la barra de búsqueda
    var filteredBeers: [Beer] {
        if searchText.isEmpty {
            return brand.beers
        } else {
            return brand.beers.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        VStack{
            List {
                //Lista de cervezas seccionada por tipo
                ForEach(BeerType.allCases, id: \.id) { value in
                    Section(value.rawValue.capitalized){
                        
                        //Listado de cervezas del tipo value filtradas
                        ForEach(filteredBeers, id: \.id) { beer in
                            if(beer.type == value.rawValue){
                                
                                //Pasar beer como binding para que pueda ser modificado
                                BeerListItem(beer: Binding<Beer> ( get: { beer }, set: { newValue in
                                    if let index = brand.beers.firstIndex(where: { $0.id == newValue.id } ) {
                                        brand.beers[index] = newValue
                                    }
                                }), brand: $brand)
                            }
                        }
                    }
                }
            }
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text(String(localized:"AddNewBeer"))
            })
            .sheet(isPresented: $isPresented, content: { AddBeerView(dismissSheet: $isPresented, brand: $brand)
            })
            .padding()
        }
        //Barra de búsqueda
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                CustomSortToolbar(id: brand.id)
            }
        }
        .navigationBarTitle(brand.title)
    }
}

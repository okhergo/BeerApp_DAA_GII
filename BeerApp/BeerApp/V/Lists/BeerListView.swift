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
                ForEach(BeerType.allCases, id: \.id) { value in
                    Section(value.rawValue.capitalized){
                        ForEach(filteredBeers, id: \.id) { beer in
                            if(beer.type == value.rawValue){
                                BeerItem(beer: Binding<Beer> (
                                    get: { beer },
                                    set: { newValue in
                                        if let index = brand.beers.firstIndex(where: { $0.id == newValue.id } ) {
                                            brand.beers[index] = newValue
                                        }
                                    }
                                ), brand: $brand)
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
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Menu {
                    Picker(selection: $vm.selectedSortField, label: Text("Sorting")) {
                        ForEach(SortField.allCases, id: \.self) { field in
                            HStack {
                                Text(field.rawValue.capitalized)
                                if vm.selectedSortField == field {
                                    Image(systemName: vm.ascending ? "arrow.up" : "arrow.down")
                                }
                            }
                        }
                    }
                    .onChange(of: vm.selectedSortField) { _ in vm.sort(withId:brand.id) }
                } label: {
                    Label("Menu", systemImage: "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .navigationBarTitle(brand.title)
    }
}

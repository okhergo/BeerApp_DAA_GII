//
//  HomeView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var isPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(BrandType.allCases, id: \.id) { value in
                    Section(){
                        Text(value.rawValue.capitalized)
                        ForEach($vm.brands, id: \.id) { $brand in
                            if(brand.type == value.rawValue){ Item(brand:$brand)
                            }
                        }
                    }
                }
            }
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text(String(localized:"AddNewBrand"))
            })
            .sheet(isPresented: $isPresented, content: { AddManufacturerView(dismissSheet: $isPresented)
            })
            .padding()
            .navigationBarTitle(String(localized:"BrandListTitle"))
        }
    }
}

struct Item: View {
    @Binding var brand: Model
    @EnvironmentObject var vm: ViewModel
    
    var body: some View{
        NavigationLink {
            ListDetailView(brand: $brand)
        } label: {
            HStack {
                Image(uiImage: UIImage(data:brand.image)!)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                    .padding()
                Text(brand.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                vm.removeBrand(withId: brand.id)
            } label : {
                Label(String(localized: "Trash"), systemImage: "trash.fill")
            }
            .tint(.red)
        }
    }
}

struct ListDetailView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var brand: Model
    @State private var isPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(BeerType.allCases, id: \.id) { value in
                    Section(){
                        Text(value.rawValue.capitalized)
                        ForEach($brand.beers, id: \.id) { $beer in
                            if(beer.type == value.rawValue){
                                BeerItem(beer:$beer, brand: $brand)
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
            .sheet(isPresented: $isPresented, content: { AddBeerView(dismissSheet: $isPresented)
            })
            .padding()
            .navigationBarTitle(brand.title)
        }
    }
}

struct BeerItem: View {
    @Binding var beer: BeerModel
    @Binding var brand: Model
    @EnvironmentObject var vm: ViewModel
    
    var body: some View{
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
    }
}

#Preview {
    ListView()
        .environmentObject(ViewModel())
}

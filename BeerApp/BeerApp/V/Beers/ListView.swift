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
        NavigationView {
            VStack{
                
                //Listado de marcas
                List {
                    ForEach(BrandType.allCases, id: \.id) { value in
                        Section(value.rawValue.capitalized){
                            ForEach($vm.brands, id: \.id) { $brand in
                                if(brand.type == value.rawValue){ BrandListItem(brand:$brand)
                                }
                            }
                        }
                    }
                }
                
                //Botón para añadir una nueva marca
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text(String(localized:"AddNewBrand"))
                })
                .sheet(isPresented: $isPresented, content: { AddManufacturerView(dismissSheet: $isPresented)
                })
                .padding()
            }
            .navigationBarTitle(String(localized:"BrandListTitle"))
        }
    }
}

#Preview {
    ListView()
        .environmentObject(ViewModel())
}

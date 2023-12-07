//
//  HomeView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct ListView: View {
    @State var descriptionNote: String = ""
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if ($vm.brands.count > 0) {
                    ForEach($vm.brands, id: \.id) { $brand in
                        NavigationLink {
                            ListDetailView(brand: $brand)
                        } label: {
                            VStack(alignment: .leading) {
                                Image(uiImage: UIImage(data:brand.image)!)
                                    .resizable()
                                    .scaledToFit()
                                Text(brand.title)
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
                } else {
                    Text(String(localized: "NoBeerAdded"))
                }
            }
            NavigationLink {
                AddView()
            } label: {
                Text(String(localized: "AddNewManufacturer"))
            }
            .padding()
            .navigationBarTitle(String(localized:"BeerListTitle"))
        }
    }
}

#Preview {
    ListView()
}

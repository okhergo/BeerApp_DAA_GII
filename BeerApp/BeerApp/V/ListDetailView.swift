//
//  ListDeailView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 7/12/23.
//

import SwiftUI

struct ListDetailView: View {
    @Binding var brand: Model
    @State var descriptionNote: String = ""
    @State var showView: Bool = false
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if ($brand.beers.count > 0) {
                    ForEach($brand.beers, id: \.id) { $beer in
                        VStack(alignment: .leading) {
                            Image(uiImage: UIImage(data:beer.image)!)
                                .resizable()
                                .scaledToFit()
                            Text(beer.title)
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
                } else {
                    Text(String(localized: "NoBeerAdded"))
                }
            }
            .navigationBarTitle(String(localized:"BeerListTitle"))
        }
    }
}

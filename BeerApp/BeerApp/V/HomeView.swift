//
//  CamView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack{
            WheatherView()
            
            //Listado de cervezas favoritas
            List {
                Section {
                    if ($vm.favorites.count > 0) {
                        ForEach($vm.favorites, id: \.id) { $fav in
                            HStack {
                                CustomProfileImage(data: fav.image)
                                Text(fav.title)
                                    .font(.title)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    vm.favoriteBeer(beer: $fav)
                                } label : {
                                    Label(String(localized: "Star"), systemImage: "star.fill")
                                }
                                .tint(.yellow)
                            }
                        }
                    } else {
                        Text(String(localized: "NoFavBeers"))
                    }
                } header: {
                    Text(String(localized: "FavoriteBeers"))
                        .frame(height: 50)
                } footer: {
                    Text(String(localized: "HowToAddFavs"))
                }
                .headerProminence(.increased)
            }
            .navigationTitle(String(localized:"HomeTitle"))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewModel())
}

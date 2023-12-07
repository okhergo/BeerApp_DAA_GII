//
//  CamView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct HomeView: View {
    @State var descriptionNote: String = ""
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack{
            WheatherView()
            List{
                
                if ($vm.favorites.count > 0) {
                    ForEach($vm.favorites, id: \.id) { $fav in
                        Text(fav.title)
                    }
                } else {
                    Text(String(localized: "NoFavBeers"))
                }
            }
            .navigationTitle(String(localized:"HomeTitle"))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewModel())
}

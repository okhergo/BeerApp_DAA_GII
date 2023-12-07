//
//  CamView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct HomeView: View {
    @State var descriptionNote: String = ""
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                Wheather()
                if ($vm.favorites.count > 0) {
                    NavigationStack{
                        ForEach($vm.favorites, id: \.id) { $fav in
                            VStack{
                                Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                ScrollView {
                                    Text(fav.caption)
                                        .padding()
                                }
                            }
                        }
                    }
                    List{
                        ForEach($vm.favorites, id: \.id) { $fav in
                            Text(fav.caption)
                        }
                    }
                } else {
                    NavigationStack {
                        Text(String(localized: "NoBeers"))
                    }
                }
            }
            .navigationTitle(String(localized:"HomeTitle"))
        }
    }
}

#Preview {
    HomeView()
}

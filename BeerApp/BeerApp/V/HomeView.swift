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
                        HStack {
                            Image(uiImage: UIImage(data:fav.image)!)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                                .padding()
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
            }
            .navigationTitle(String(localized:"HomeTitle"))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewModel())
}

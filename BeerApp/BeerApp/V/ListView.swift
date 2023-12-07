//
//  HomeView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import SwiftUI

struct ListView: View {
    @State var descriptionNote: String = ""
    @State var showView: Bool = false
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationView{
            List {
                if ($vm.posts.count > 0) {
                    ForEach($vm.posts, id: \.id) { $post in
                        HStack {
                            if post.isFavorited {
                                Text("⭐️")
                            }
                            Text(post.caption)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                vm.favorite(post: $post)
                            } label : {
                                Label(String(localized: "Star"), systemImage: "star.fill")
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                vm.remove(withId: post.id)
                            } label : {
                                Label(String(localized: "Trash"), systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                } else {
                    Text(String(localized: "NoBeer"))
                }
            }
            .navigationBarTitle(String(localized:"BeerListTitle"))
            .navigationBarItems(trailing: NavigationLink(
                destination: AddView(showView: $showView),
                isActive: $showView){
                    Image(systemName: "plus")})
        }
    }
}


var temp = 10
var city = "San Francisco"

struct Wheather: View {
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .padding(10)
                .frame(height: 150)
            HStack {
                Text("\(temp)")
                    .foregroundColor(.blue)
                    .font(.title) .fontWeight(.bold)
                VStack{
                    Text("\(city)")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text(String(localized: "WheaterSubtitle"))
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }

        }
    }
}

#Preview {
    ListView()
}

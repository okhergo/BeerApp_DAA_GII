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
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationView{
            List {
                if ($vm.posts.count > 0) {
                    ForEach($vm.posts, id: \.id) { $post in
                        VStack(alignment: .leading) {
                            Image(uiImage: post.image.img!)
                                .resizable()
                                .scaledToFit()
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
                    Text(String(localized: "NoBeerAdded"))
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

#Preview {
    ListView()
}

//
//  ListItems.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI

struct Item: View {
    @Binding var brand: Brand
    @EnvironmentObject var vm: ViewModel
    
    var body: some View{
        NavigationLink {
            BeerListView(brand: $brand)
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

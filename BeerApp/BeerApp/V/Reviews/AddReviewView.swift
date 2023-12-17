//
//  AddReviewView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 14/12/23.
//

import SwiftUI
import PhotosUI

struct AddReviewView: View {
    @Binding var dismissSheet: Bool
    @FocusState private var focusedField: Field?
    @ObservedObject var userVM: UserViewModel
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack{
            Form {
                Picker(String(localized:"SelectReviewBeer"), selection: $userVM.beerId) {
                    ForEach($vm.brands) { brand in
                        ForEach(brand.beers){ beer in
                            Text(brand.wrappedValue.title + " " + beer.wrappedValue.title).tag(beer.id)
                        }
                    }
                }
                VStack {
                    HStack {
                        ForEach((1...userVM.points) , id: \.self) {_ in
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }
                        if(userVM.points < 5){
                            ForEach((userVM.points...4) , id: \.self) {_ in
                                Image(systemName: "star.fill").foregroundColor(.gray)
                            }
                        }
                    }.padding()
                    Picker(String(localized:"SelectReviewPoints"), selection: $userVM.points) {
                        ForEach((1...5), id: \.self) {
                            Text("\($0)").tag($0)
                        }
                    }.pickerStyle(.segmented)
                }
                TextField(String(localized:"InsertReviewCaption"), text: $userVM.caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    if let imageData = userVM.selectedImageData, let selectedImage = UIImage(data:imageData) {
                        Image(uiImage: selectedImage)
                            .resizable().scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding()
                    }
                    PhotosPicker( selection: $userVM.selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text(String(localized:"SelectReviewPhoto"))
                    }
                    .onChange(of: userVM.selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self){
                                userVM.selectedImageData = data
                            }
                        }
                    }
                }
            }
            HStack {
                Button(action: {
                    clearFields() })
                { Text(String(localized: "Dismiss")) }
                    .foregroundColor(.red)
                Button(action: {
                    guard !userVM.caption.isEmpty else { return }
                    userVM.saveReview()
                    clearFields() })
                { Text(String(localized: "Save")) }
            } 
            .padding()
            .onAppear(){
                userVM.beerId = vm.brands[0].beers[0].id
            }
        }
    }
    
    func clearFields(){
        userVM.selectedItem = nil
        userVM.selectedImageData = nil
        userVM.beerId = ""
        userVM.caption = ""
        userVM.points = 1
        dismissSheet = false
    }
}

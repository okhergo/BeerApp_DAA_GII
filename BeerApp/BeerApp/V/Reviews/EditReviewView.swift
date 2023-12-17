//
//  EditReviewView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 14/12/23.
//

import SwiftUI
import PhotosUI

struct EditReviewView: View {
    @Binding var dismissSheet: Bool
    @Binding var review: ReviewE
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Picker(String(localized:"SelectReviewBeer"), selection: $userVM.beerId) {
                    ForEach($vm.brands) { brand in
                        ForEach(brand.beers){ beer in
                            Text(brand.wrappedValue.title + " " +  beer.wrappedValue.title).tag(beer.id)
                        }
                    }
                }
                Picker(String(localized:"SelectReviewPoints"), selection: $userVM.points) {
                    ForEach((1...5), id: \.self) {
                        Text("\($0)").tag($0)
                    }
                }
                VStack{
                    Text(String(localized:"InsertReviewCaption"))
                    TextField(userVM.caption, text: $userVM.caption)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    if let imageData = userVM.selectedImageData, let selectedImage = UIImage(data:imageData) {
                        Image(uiImage: selectedImage)
                            .resizable() .frame(width: 40, height: 40)
                            .scaledToFill() .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding()
                    }
                    PhotosPicker(selection: $userVM.selectedItem,  matching: .images, photoLibrary: .shared()) {
                        Text(String(localized:"SelectReviewFoto"))
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
                { Text(String(localized: "DiscardChanges")) }
                    .foregroundColor(.red)
                Button(action: {
                    if (userVM.selectedImageData == nil){
                        if (review.image != nil){ userVM.selectedImageData = review.image }
                    }
                    userVM.saveReview()
                    userVM.removeReview(withId: review.id!)
                    clearFields() })
                { Text(String(localized: "Update")) }
            } .padding()
        }
        .onAppear(){
            userVM.points = Int(review.points)
            userVM.caption = review.caption!
            userVM.beerId = review.beer!.id!
            userVM.selectedImageData = review.image
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Image(systemName: "chevron.backward"))
    }
    
    func clearFields(){
        userVM.selectedItem = nil
        userVM.selectedImageData = nil
        userVM.beerId = ""
        userVM.points = 0
        userVM.caption = ""
        dismissSheet = false
    }
}

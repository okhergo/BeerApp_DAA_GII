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
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var vm: ViewModel
    var review: Binding<ReviewE>?
    
    var body: some View {
        NavigationStack{
            Form {
                //Selector de cerveza
                Picker(String(localized:"SelectReviewBeer"), selection: $userVM.beerId) {
                    ForEach($vm.brands) { brand in
                        ForEach(brand.beers){ beer in
                            Text(brand.wrappedValue.title + " " + beer.wrappedValue.title).tag(beer.id)
                        }
                    }
                }
                
                //Selector de puntuación por estrellas personalizado
                CustomStarsPicker()
                
                //Campo de texto de la reseña
                TextField(String(localized:"InsertReviewCaption"), text: $userVM.caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                //Selector de imagen personalizado
                CustomImageReviewPicker()
            }
            
            HStack {
                Button(action: {
                    clearFields() })
                { Text(String(localized: "Dismiss")) }
                    .foregroundColor(.red)
                Button(action: {
                    guard !userVM.caption.isEmpty else { return }
                    if review != nil { userVM.removeReview(withId: review!.id!) }
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

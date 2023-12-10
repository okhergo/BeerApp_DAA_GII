//
//  AddBeerView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI
import PhotosUI

struct AddBeerView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var dismissSheet: Bool
    @Binding var brand: Brand
    
    var body: some View {
        NavigationStack{
            Form {
                HStack {
                    if let imageData = vm.selectedImageData, let selectedImage = UIImage(data:imageData) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                            .padding()
                    }
                    PhotosPicker(
                        selection: $vm.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text(String(localized:"SelectBeerFoto"))
                        }
                        .onChange(of: vm.selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self){
                                    vm.selectedImageData = data
                                }
                            }
                        }
                }
                TextField(String(localized:"InsertBeerName"), text: $vm.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Picker(String(localized:"SelectBeerType"), selection: $vm.typeBeer) {
                    ForEach(BeerType.allCases, id: \.id) { value in
                        Text(value.rawValue.capitalized)
                            .tag(value)
                    }
                }
                TextField(String(localized:"InsertGrades"), text: $vm.grades)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField(String(localized:"InsertCalories"), text: $vm.cal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Button(action: {
                    vm.selectedImageData = nil
                    vm.title = ""
                    dismissSheet = false })
                { Text(String(localized: "Dismiss")) }
                    .foregroundColor(.red)
                Button(action: {
                    guard (vm.selectedImageData != nil) else { return }
                    guard !vm.title.isEmpty else { return }
                    guard !vm.grades.isEmpty else { return }
                    guard !vm.cal.isEmpty else { return }
                    vm.saveBeer(withId: brand.id)
                    vm.selectedImageData = nil
                    vm.title = ""
                    vm.grades = ""
                    vm.cal = ""
                    dismissSheet = false })
                { Text(String(localized: "Save")) }
            } .padding()
        }
    }
}
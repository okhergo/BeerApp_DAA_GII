//
//  EditBeerView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 9/12/23.
//

import SwiftUI
import PhotosUI

struct EditBeerView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var dismissSheet: Bool
    @Binding var brand: Brand
    @Binding var beer: Beer
    
    var body: some View {
        NavigationView{
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
                    } else {
                        Image(uiImage: UIImage(data:beer.image)!)
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
                VStack{
                    Text(String(localized:"InsertBeerName"))
                    TextField(beer.title, text: $vm.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                Picker(String(localized:"SelectBeerType"), selection: $vm.typeBeer) {
                    ForEach(BeerType.allCases, id: \.id) { value in
                        Text(value.rawValue.capitalized)
                            .tag(value)
                    }
                }
                VStack{
                    Text(String(localized:"InsertGrades"))
                    TextField("\(beer.grades)", text: $vm.grades)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                VStack{
                    Text(String(localized:"InsertCalories"))
                    TextField("\(beer.cal)", text: $vm.cal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
            HStack {
                Button(action: {
                    vm.selectedImageData = nil
                    vm.title = ""
                    vm.grades = ""
                    vm.cal = ""
                    dismissSheet = false })
                { Text(String(localized: "DiscardChanges")) }
                    .foregroundColor(.red)
                Button(action: {
                    if (vm.selectedImageData == nil){ vm.selectedImageData = beer.image }
                    if vm.title.isEmpty { vm.title = beer.title }
                    if vm.grades.isEmpty { vm.grades = "\(beer.grades)" }
                    if vm.cal.isEmpty { vm.cal = "\(beer.cal)" }
                    vm.removeBeer(withId: beer.id, withBrandId: brand.id)
                    vm.saveBeer(withId: brand.id)
                    vm.selectedImageData = nil
                    vm.title = ""
                    vm.grades = ""
                    vm.cal = ""
                    dismissSheet = false })
                { Text(String(localized: "Update")) }
            } .padding()
        }
    }
}


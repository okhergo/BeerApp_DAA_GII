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
    @State var result: String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    HStack {
                        if let imageData = vm.selectedImageData, let selectedImage = UIImage(data:imageData) {
                            Image(uiImage: selectedImage)
                                .resizable() .frame(width: 40, height: 40)
                                .scaledToFill() .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(Circle().stroke(Color.blue, lineWidth: 1)) .padding()
                        } else {
                            Image(uiImage: UIImage(data:beer.image)!)
                                .resizable() .frame(width: 40, height: 40)
                                .scaledToFill() .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(Circle().stroke(Color.blue, lineWidth: 1)) .padding()
                        }
                        PhotosPicker(selection: $vm.selectedItem,  matching: .images, photoLibrary: .shared()) {
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
                Text(result)
                HStack {
                    Button(action: {
                        clearFields() })
                    { Text(String(localized: "DiscardChanges")) }
                        .foregroundColor(.red)
                    Button(action: {
                        result = vm.saveBeer(withId: brand.id)
                        if result.isEmpty {
                            vm.removeBeer(withId: beer.id, withBrandId: brand.id)
                        } else { return }
                        clearFields() })
                    { Text(String(localized: "Update")) }
                } .padding()
            }
        }
        .onAppear(){
            vm.title = beer.title
            vm.grades = String(beer.grades)
            vm.cal = String(beer.cal)
            vm.selectedImageData = beer.image
        }
    }
    
    func clearFields(){
        vm.selectedItem = nil
        vm.selectedImageData = nil
        vm.title = ""
        vm.grades = ""
        vm.cal = ""
        dismissSheet = false
    }
}


//
//  AddView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 6/12/23.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @StateObject var vm = ViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack{
            if let imageData = vm.selectedImageData, let selectedImage = UIImage(data:imageData) {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                    .padding()
            }
            Form {
                PhotosPicker(
                    selection: $vm.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text(String(localized:"SelectManufacturerLogo"))
                    }
                    .onChange(of: vm.selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self){
                                vm.selectedImageData = data
                            }
                        }
                    }
                
                Section{
                    Text(String(localized:"InsertBrandName"))
                    TextField("", text: $vm.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Section{
                    Text(String(localized:"InsertBrandType"))
                    TextField("", text: $vm.type)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Button(action: {
                        vm.selectedImageData = nil
                        vm.title = ""
                        vm.type = ""
                        self.presentationMode.wrappedValue.dismiss() })
                    { Text(String(localized: "Dismiss")) }
                    Button(action: {
                        guard !vm.type.isEmpty else { return }
                        guard !vm.title.isEmpty else { return }
                        vm.saveBrand()
                        vm.selectedImageData = nil
                        vm.title = ""
                        vm.type = ""
                        self.presentationMode.wrappedValue.dismiss() })
                    { Text(String(localized: "Publish")) }
                }
            }
        }
        .navigationTitle(String(localized: "AddNewManufacturer"))
    }
}

#Preview {
    AddView()
}

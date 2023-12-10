//
//  AddView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 6/12/23.
//

import SwiftUI
import PhotosUI

struct AddManufacturerView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var dismissSheet: Bool
    @FocusState private var focusedField: Field?
    
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
                            Text(String(localized:"SelectManufacturerLogo"))
                        }
                        .onChange(of: vm.selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self){
                                    vm.selectedImageData = data
                                }
                            }
                        }
                }
                TextField(String(localized:"InsertBrandName"), text: $vm.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Picker(String(localized:"SelectBrandType"), selection: $vm.type) {
                    ForEach(BrandType.allCases, id: \.id) { value in
                        Text(value.rawValue.capitalized)
                            .tag(value)
                    }
                }
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
                    vm.saveBrand()
                    vm.selectedImageData = nil
                    vm.title = ""
                    dismissSheet = false })
                { Text(String(localized: "Save")) }
            } .padding()
        }
    }
}

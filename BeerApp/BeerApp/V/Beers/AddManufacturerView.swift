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
                //Selector de imagen del fabricante
                CustomImageBeersPicker(fieldTitle: String(localized:"SelectManufacturerLogo"))
                
                //Campo del nombre
                TextField(String(localized:"InsertBrandName"), text: $vm.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                //Selector del tipo de fabricante
                Picker(String(localized:"SelectBrandType"), selection: $vm.type) {
                    ForEach(BrandType.allCases, id: \.id) { value in
                        Text(value.rawValue.capitalized)
                            .tag(value)
                    }
                }
            }
            HStack {
                Button(action: {
                    clearFields() })
                { Text(String(localized: "Dismiss")) }
                    .foregroundColor(.red)
                Button(action: {
                    guard (vm.selectedImageData != nil) else { return }
                    guard !vm.title.isEmpty else { return }
                    vm.saveBrand()
                    clearFields() })
                { Text(String(localized: "Save")) }
            } .padding()
        }
    }
    
    func clearFields(){
        vm.selectedItem = nil
        vm.selectedImageData = nil
        vm.title = ""
        dismissSheet = false
    }
}

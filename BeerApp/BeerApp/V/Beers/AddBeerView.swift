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
    var beer: Binding<Beer>?
    @State var result: String = ""
    
    var body: some View {
        NavigationStack{
            Form {
                CustomImageBeersPicker(fieldTitle: String(localized:"SelectBeerPhoto"))
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
            Text(result)
            HStack {
                Button(action: {
                    clearFields() })
                { Text(String(localized: "Dismiss")) }
                    .foregroundColor(.red)
                Button(action: {
                    guard (vm.selectedImageData != nil) else { result = String(localized: "EmptyFields"); return }
                    guard !vm.title.isEmpty else { result = String(localized: "EmptyFields"); return }
                    guard !vm.grades.isEmpty else { result = String(localized: "EmptyFields"); return }
                    guard !vm.cal.isEmpty else { result = String(localized: "EmptyFields"); return }
                    if (beer != nil) { vm.removeBeer(withId: beer!.id, withBrandId: brand.id) }
                    result = vm.saveBeer(withId: brand.id)
                    clearFields() })
                { Text(String(localized: "Save")) }
            } .padding()
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

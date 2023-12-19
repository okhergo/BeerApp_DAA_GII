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
        //Mismo formulario que para añadir, pero cargando los datos originales
        AddBeerView(dismissSheet: $dismissSheet, brand: $brand)
        .onAppear(){
            vm.title = beer.title
            vm.grades = String(beer.grades)
            vm.cal = String(beer.cal)
            vm.selectedImageData = beer.image
        }
    }
}


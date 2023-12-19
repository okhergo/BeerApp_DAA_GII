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
        //Mismo formulario que para añadir, pero cargando los datos originales
        AddReviewView(dismissSheet: $dismissSheet)
        .onAppear(){
            userVM.points = Int(review.points)
            userVM.caption = review.caption!
            userVM.beerId = review.beer!.id!
            userVM.selectedImageData = review.image
        }
    }
}

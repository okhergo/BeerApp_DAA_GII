//
//  CustomViews.swift
//  BeerApp
//
//  Created by Óscar Khergo on 19/12/23.
//

import SwiftUI
import PhotosUI

//Item del listado de marcas
struct BrandListItem: View {
    @Binding var brand: Brand
    @EnvironmentObject var vm: ViewModel
    
    var body: some View{
        NavigationLink {
            BeerListView(brand: $brand)
        } label: {
            HStack {
                CustomProfileImage(data:brand.image, size:50)
                Text(brand.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                vm.removeBrand(withId: brand.id)
            } label : {
                Label(String(localized: "Trash"), systemImage: "trash.fill")
            }
            .tint(.red)
        }
    }
}

//Item del listado de cervezas
struct BeerListItem: View {
    @Binding var beer: Beer
    @Binding var brand: Brand
    @EnvironmentObject var vm: ViewModel
    @State var isPresented: Bool = false
    
    var body: some View{
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack {
                CustomProfileImage(data:beer.image, size:50)
                VStack (alignment: .leading){
                    Text(beer.title)
                        .font(.title2).bold().foregroundColor(.primary)
                    Text(String(format: "%.1f", beer.grades) + "% ºC | "  + String(format: "%.0f", beer.cal) + " kcal")
                        .font(.subheadline).foregroundColor(.primary)
                }
            }
            .swipeActions(edge: .trailing) {
                Button {
                    vm.favoriteBeer(beer: $beer)
                } label : {
                    Label(String(localized: "Star"), systemImage: "star.fill")
                }
                .tint(.yellow)
            }
            .swipeActions(edge: .leading) {
                Button {
                    vm.removeBeer(withId: beer.id, withBrandId: brand.id)
                } label : {
                    Label(String(localized: "Trash"), systemImage: "trash.fill")
                }
                .tint(.red)
            }
        })
        .sheet(isPresented: $isPresented, content: {
            BeerDetailView(beer: $beer, brand: $brand)
        })
    }
}

//Item del listado de reseñas
struct ReviewItem: View {
    @Binding var review: ReviewE
    @EnvironmentObject var userVM: UserViewModel
    @State var isPresented: Bool = false
    
    var body: some View{
        if(($userVM.reviews.first(where: {$0.id == review.id})) != nil){
            Button(action: {
                isPresented.toggle()
            }, label: {
                VStack (alignment: .leading, spacing: 10){
                    if(review.beer != nil){
                        Text(review.beer!.brand!.title! + " " + review.beer!.title!)
                    }
                    HStack{
                        ForEach((1...review.points) , id: \.self) {_ in
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }
                        if(review.points < 5){
                            ForEach((review.points...4) , id: \.self) {_ in
                                Image(systemName: "star.fill").foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
                .swipeActions(edge: .leading) {
                    Button {
                        userVM.removeReview(withId: review.id!)
                    } label : {
                        Label(String(localized: "Trash"), systemImage: "trash.fill")
                    }
                    .tint(.red)
                }
            })
            .sheet(isPresented: $isPresented, content: {
                ReviewDetailView(review: $review)
            })
        }
    }
}

//Selector de campo de ordenación
struct CustomSortToolbar: View{
    @EnvironmentObject var vm: ViewModel
    @State var id: String
    var body: some View{
        Menu {
            Picker(selection: $vm.selectedSortField, label: Text("Sorting")) {
                ForEach(SortField.allCases, id: \.self) { field in
                    HStack {
                        Text(field.rawValue.capitalized)
                        if vm.selectedSortField == field {
                            Image(systemName: vm.ascending ? "arrow.up" : "arrow.down")
                        }
                    }
                }
            }
            .onChange(of: vm.selectedSortField) { _ in vm.sort(withId:id) }
        } label: {
            Label("Menu", systemImage: "line.3.horizontal.decrease.circle.fill")
        }
    }
}
//Selector de imagen personalizado para las reseñas
struct CustomImageReviewPicker: View{
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View{
        HStack {
            if let imageData = userVM.selectedImageData, let selectedImage = UIImage(data:imageData) {
                Image(uiImage: selectedImage)
                    .resizable().scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding()
            }
            PhotosPicker( selection: $userVM.selectedItem, matching: .images, photoLibrary: .shared()) {
                Text(String(localized:"SelectReviewPhoto"))
            }
            .onChange(of: userVM.selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self){
                        userVM.selectedImageData = data
                    }
                }
            }
        }
    }
}

//Selector de imagen personalizado para los fabricantes o cervezas
struct CustomImageBeersPicker: View {
    @EnvironmentObject var vm: ViewModel
    @State var fieldTitle: String
    
    var body: some View{
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
            PhotosPicker( selection: $vm.selectedItem, matching: .images, photoLibrary: .shared()) {
                Text(fieldTitle)
            }
            .onChange(of: vm.selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self){
                        vm.selectedImageData = data
                    }
                }
            }
        }
    }
}

//Selector de puntuación por estrellas personalizado
struct CustomStarsPicker: View{
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View{
        VStack {
            CustomStarsSelected(points: $userVM.points)
            
            Picker(String(localized:"SelectReviewPoints"), selection: $userVM.points) {
                ForEach((1...5), id: \.self) {
                    Text("\($0)").tag($0)
                }
            }.pickerStyle(.segmented)
        }
    }
}

//Estilo de estrellas seleccionadas
struct CustomStarsSelected: View{
    @Binding var points: Int
    
    var body: some View{
        HStack {
            ForEach((1...points) , id: \.self) {_ in
                Image(systemName: "star.fill").foregroundColor(.yellow)
            }
            if(points < 5){
                ForEach((points...4) , id: \.self) {_ in
                    Image(systemName: "star.fill").foregroundColor(.gray)
                }
            }
        }.padding()
    }
}

//Estilo personalizado de imagen en círculo bordeado
struct CustomProfileImage: View {
    @State var data: Data
    @State var size: Float
    
    var body: some View {
        Image(uiImage: UIImage(data: data)!)
            .resizable()
            .frame(width: CGFloat(size), height: CGFloat(size))
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(size)/2))
            .overlay(Circle().stroke(Color.blue, lineWidth: 1))
            .padding()
    }
}

//Estilo personalizado del fondo del tiempo
struct CustomWeatherBackground:View{
    @State var imageURL: String
    @State var opacity: Double
    @State var color: Color
    
    var body: some View{
        Image(imageURL)
            .resizable()
            .frame(height: 150)
            .cornerRadius(10)
            .padding(10)
        Rectangle()
            .opacity(opacity)
            .foregroundColor(color)
            .frame(height: 150)
            .cornerRadius(10)
            .padding(10)
    }
}

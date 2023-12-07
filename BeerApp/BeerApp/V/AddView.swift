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
    @Binding var showView: Bool
    
    var body: some View {
        if let selectedImage = vm.selectedImage {
            VStack {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                TextField("Escribe un título...", text: $vm.captionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack{
                    Button(action: {
                        guard !vm.captionText.isEmpty else { return }
                        vm.savePost(image: selectedImage)
                        vm.selectedImage = nil
                        vm.captionText = ""
                        self.showView = false })
                    { Text("Publicar") }
                    Button(action: {
                        vm.selectedImage = nil
                        vm.captionText = ""
                        self.showView = false })
                    { Text("Descartar") }
                }
            }
        } else {
            Button("Selecciona una imagen") {
                vm.isImagePickerPresented = true
            }
            .sheet(isPresented: $vm.isImagePickerPresented) {
                PhotoPicker(selectedImage: $vm.selectedImage)
            }
        }
    }
}
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

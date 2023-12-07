//
//  ViewModel.swift
//  BeerApp
//
//  Created by Óscar Khergo on 5/12/23.
//

import Foundation
import SwiftUI

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

extension String {
    var img: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

final class ViewModel: ObservableObject {
    @Published var posts: [Model] = []
    @Published var favorites: [Model] = []
    @Published var isImagePickerPresented = false
    @Published var selectedImage: UIImage?
    @Published var captionText: String = ""
    @Published var title: String = ""
    
    init() {
        posts = getAll()
    }
    
    func savePost(image: UIImage) {
        let newPost = Model(title: title, image: image.base64!, caption: captionText)
        posts.insert(newPost, at: 0)
    }
    
    private func encodeAll() {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.setValue(encoded, forKey: "posts")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAll() -> [Model] {
        if let postsData = UserDefaults.standard.object(forKey: "posts") as? Data {
            if let posts = try? JSONDecoder().decode([Model].self, from: postsData) {
                return posts
            }
        }
        return []
    }
    
    func remove(withId id: String) {
        posts.removeAll(where: { $0.id == id })
        encodeAll()
    }
    
    func favorite(post: Binding<Model>) {
        post.wrappedValue.isFavorited = !post.wrappedValue.isFavorited
        encodeAll()
    }
    
    func getNumberOfNotes() -> String {
        "\(posts.count)"
    }
}

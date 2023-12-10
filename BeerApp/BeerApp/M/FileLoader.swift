//
//  FileLoader.swift
//  BeerApp
//
//  Created by Óscar Khergo on 10/12/23.
//

import Foundation

class FileLoader {
    //READ FROM PROJECT BUNDLE
    static func readLocalFile(_ filename: String) -> Data? {
        guard let file = Bundle.main.path(forResource: filename, ofType: "json")
        else {
            fatalError("Unable to locate file \"\(filename)\" in main bundle.")
        }
        
        do {
            return try String(contentsOfFile: file).data(using: .utf8)
        } catch {
            fatalError("Unable to load \"\(filename)\" from main bundle:\n\(error)")
        }
    }
    
    static func loadJson(_ data: Data) -> [Brand] {
        do {
            return try JSONDecoder().decode([Brand].self, from: data)
        } catch {
            fatalError("Unable to decode  \"\(data)\" as \([Brand].self):\n\(error)")
        }
    }
    
    //WRITE IN DOCUMENTS DIRECTORY
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func saveDataToDocuments(_ data: Data, jsonFilename: String = "BeersData.json") {
        let jsonFileURL = getDocumentsDirectory().appendingPathComponent(jsonFilename)
        do {
            try data.write(to: jsonFileURL)
        } catch {
            print("Error = \(error)")
        }
    }
}

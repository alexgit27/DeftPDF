//
//  UserDefaultsManager.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 04.07.2022.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let key = "FilePDF"
    private init() {}
    
    func savePDF(data file: ModelPDF) {
        guard let data = try? PropertyListEncoder().encode(file) else { return }
        
        if let files = UserDefaults.standard.object(forKey: key) as? [Data] {
            var _files = files
            _files.insert(data, at: 0)
            UserDefaults.standard.set(_files, forKey: key)
        } else {
            UserDefaults.standard.set([data], forKey: key)
        }
    }
    
    func getPDF() -> [ModelPDF] {
        guard let data =  UserDefaults.standard.object(forKey: key) as? [Data] else {
            return []
        }
        let decodedData = data
            .map { try? PropertyListDecoder().decode(ModelPDF.self, from: $0) }
            .compactMap { $0 }
        return decodedData
       
    }
    func removePDF(data file: ModelPDF) {
        guard let data = try? PropertyListEncoder().encode(file) else { return }
        
        if let files = UserDefaults.standard.object(forKey: key) as? [Data], let fileIndex = files.firstIndex(of: data) {
            var _files = files
            _files.remove(at: fileIndex)
            UserDefaults.standard.set(_files, forKey: key)
        }
    }
}

//
//  Model.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 05.07.2022.
//

import Foundation

enum SectionsPDF: CaseIterable {
    case main
}

struct ModelPDF: Codable, Hashable {
    let pdfData: Data
    let date: Date?
    let title: String
    
    //MARK: Hashable
    var uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: ModelPDF, rhs: ModelPDF) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

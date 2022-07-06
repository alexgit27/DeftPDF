//
//  Extension+UIImageView.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 04.07.2022.
//

import UIKit

extension UIImageView {
    static func drawPDFfromData(_ data: Data) -> UIImage? {

        guard let provider = CGDataProvider(data: data as CFData) else { return nil }
        guard let document = CGPDFDocument(provider) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }
        return img
    }
}

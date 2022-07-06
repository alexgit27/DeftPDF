//
//  DetailsPDFVC.swift
//  DeftPDF
//
//  Created by Alexandr Ananchenko on 05.07.2022.
//

import UIKit
import PDFKit

class DetailsPDFVC: UIViewController {
    private let pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit;
        pdfView.autoScales = true;
        
        return pdfView
    }()
    
    private let pdfData: Data
    init(pdfData: Data) {
        self.pdfData = pdfData
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pdfView)
        setupPDFView()
    }

    override func viewDidLayoutSubviews() {
        pdfView.frame = view.frame
    }
    
    private func setupPDFView() {
        guard let pdf = PDFDocument(data: pdfData) else { return }
        pdfView.document = pdf
    }
}

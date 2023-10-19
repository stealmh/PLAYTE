//
//  PDFViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/09/09.
//

import UIKit
import PDFKit
import SnapKit

class PDFViewController: BaseViewController {
    
    private let pdfView = PDFView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        
        pdfView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        let url = Bundle.main.url(forResource: "term", withExtension: "pdf")
        if let url = url, let document = PDFDocument(url: url) {
            loadPDFView(document: document)
        }

    }
    
    private func loadPDFView(document: PDFDocument) {
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = document
    }

}

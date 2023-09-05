//
//  PDFViewerController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/30.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    
    var pdfURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PDF Viewer"
        view.backgroundColor = .white
        
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let pdfDocument = PDFDocument(url: pdfURL) {
            pdfView.document = pdfDocument
        }
        
        view.addSubview(pdfView)
    }
}

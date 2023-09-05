//
//  TermsViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/08/21.
//

import SnapKit
import RxSwift
import RxCocoa
import UIKit
import PDFKit

class TermsViewController: UIViewController {
    
    private let termLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .grayScale6
        v.text = "플레이트 통합 서비스 약관"
        return v
    }()
    
    private let showPDFButton: UIButton = {
        let v = UIButton()
        v.setTitle("다운로드", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.setTitleColor(.grayScale4, for: .normal)
        return v
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "이용약관"
        view.backgroundColor = .white
        
        view.addSubview(termLabel)
        view.addSubview(showPDFButton)
        termLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().inset(30)
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        showPDFButton.snp.makeConstraints {
            $0.centerY.equalTo(termLabel)
            $0.right.equalToSuperview().inset(30)
        }
        
        showPDFButton.rx.tap
            .subscribe(onNext: { _ in
                guard let pdfURL = URL(string: "https://github.com/stealmh/TIL/blob/main/term.pdf") else {
                    return
                }
                
                URLSession.shared.dataTask(with: pdfURL) { (data, response, error) in
                    guard let data = data, error == nil else {
                        print("Error downloading PDF: \(error?.localizedDescription ?? "")")
                        return
                    }
                    
                    // Get the documents directory URL
                    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let pdfFileURL = documentsDirectory.appendingPathComponent("downloaded.pdf")
                        
                        // Save the PDF data to the documents directory
                        do {
                            try data.write(to: pdfFileURL)
                            print("PDF downloaded and saved to: \(pdfFileURL)")
                            
                            // Display an alert to let the user know the download is complete
                            DispatchQueue.main.async {
                                self.showDownloadCompleteAlert(pdfFileURL)
                            }
                        } catch {
                            print("Error saving PDF: \(error.localizedDescription)")
                        }
                    }
                }.resume()
            }).disposed(by: disposeBag)
        
//        showPDFButton.addTarget(self, action: #selector(showPDF), for: .touchUpInside)
    }
    @objc func downloadPDF() {
        guard let pdfURL = URL(string: "https://example.com/sample.pdf") else {
            return
        }
        
        URLSession.shared.dataTask(with: pdfURL) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error downloading PDF: \(error?.localizedDescription ?? "")")
                return
            }
            
            // Get the documents directory URL
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pdfFileURL = documentsDirectory.appendingPathComponent("downloaded.pdf")
                
                // Save the PDF data to the documents directory
                do {
                    try data.write(to: pdfFileURL)
                    print("PDF downloaded and saved to: \(pdfFileURL)")
                    
                    // Display an alert to let the user know the download is complete
                    DispatchQueue.main.async {
                        self.showDownloadCompleteAlert(pdfFileURL)
                    }
                } catch {
                    print("Error saving PDF: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func showDownloadCompleteAlert(_ fileURL: URL) {
        showToastSuccess(message: "다운로드가 완료되었습니다")
//        let alert = UIAlertController(title: "Download Complete", message: "The PDF has been downloaded and saved.", preferredStyle: .alert)
//        
//        let openAction = UIAlertAction(title: "Open PDF", style: .default) { _ in
//            // Implement code to open and display the PDF using the saved file URL
//            // For example, push a PDF viewer view controller with the PDF file URL
//            let pdfViewerViewController = PDFViewerViewController()
//               pdfViewerViewController.pdfURL = fileURL
//            print(fileURL)
//            self.navigationController?.pushViewController(pdfViewerViewController, animated: true)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        alert.addAction(openAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
    }
    
    
    func downloadTapped() {
        if let pdfURL = Bundle.main.url(forResource: "term", withExtension: "pdf") {
            let pdfView = PDFView(frame: view.bounds)
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            pdfView.document = PDFDocument(url: pdfURL)
            
            let pdfViewController = UIViewController()
            pdfViewController.view = pdfView
            pdfViewController.navigationItem.title = "PDF Viewer"
        }
    }
}

//MARK: - Preview
import SwiftUI
@available(iOS 13.0, *)
struct TermsViewController_Preview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: TermsViewController()).toPreview()
    }
}

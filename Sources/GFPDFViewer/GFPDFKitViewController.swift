//
//  GFPDFKitViewController.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 11/04/2019.
//

import PDFKit
import UIKit

@available(iOS 11.0, *)
class GFPDFKitViewController: UIViewController {
    
    private var configuration = GFPDFConfiguration()
    private var pdfView = PDFView()
    
    init(configuration:GFPDFConfiguration) {
        super.init(nibName: nil, bundle: nil)
        self.configuration = configuration
        pdfView.frame = self.view.frame
        self.view.addSubview(pdfView)
        configurePDFView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func loadPDFDocument(document: PDFDocument) {
        pdfView.document = document
    }
    
    // MARK: - Private
    private func configurePDFView() {
        if configuration.scrollVertically {
            pdfView.displayDirection = .vertical
        }
        else {
            pdfView.displayDirection = .horizontal
        }
        pdfView.contentMode = .scaleAspectFit
        pdfView.maxScaleFactor = 4.0
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.autoScales = true
    }
}

// MARK: - GFPDFViewer protocol

@available(iOS 11.0, *)
extension GFPDFKitViewController : GFPDFViewer {
    func resize(toFrame frame: CGRect) {
        pdfView.frame = frame
    }
    
    func setNumberOfPagesOnScreen(_ pages: Int) {
        if pages > 1 && configuration.sideBySideLandscape {
            pdfView.displayMode = .twoUpContinuous
        }
        else {
            pdfView.displayMode = .singlePageContinuous
        }
    }
    
    
}

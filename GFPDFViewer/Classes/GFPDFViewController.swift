//
//  GFPDFViewController.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import PDFKit
import UIKit

public class GFPDFViewController: UIViewController {

    var configuration = GFPDFConfiguration()
    private var containerFrame:CGRect {
        return CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
    }
    private var pagesOnScreen = 1
    private var provider = GFPDFDocumentProvider()
    private var pdfScrollViewController:GFPDFScrollViewController?
    private var pdfView:UIView?
    
    public init(withConfiguration:GFPDFConfiguration) {
        super.init(nibName: nil, bundle: nil)
        configuration = withConfiguration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setPagesPerScreen(forSize: self.view.frame.size)
    }
    
    public func resize(toFrame frame:CGRect) {
        view.frame = frame
        setPagesPerScreen(forSize: frame.size)
        pdfScrollViewController?.resize(toFrame: frame)
        pdfView?.frame = frame
    }
    
    public func showPDF(atPath path:String) {
        if configuration.usePDFKit {
            showPDFInPDFView(path: path)
        }
        else {
            showPDFInScrollView(path: path)
        }
    }
}

// MARK: - Private

extension GFPDFViewController {
    
    private func configurePDFView() {
        if #available(iOS 11.0, *) {
            guard let pdfView = self.pdfView as? PDFView else {return}
            if pagesOnScreen == 1 {
                pdfView.displayMode = .singlePageContinuous
            }
            else {
                pdfView.displayMode = .twoUpContinuous
            }
            pdfView.contentMode = .scaleAspectFit
            pdfView.maxScaleFactor = 4.0
            pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
            pdfView.autoScales = true
        }
    }
    
    private func configureScrollViewController() {
        if pdfScrollViewController == nil {
            pdfScrollViewController = GFPDFScrollViewController(configuration: configuration, dataSource: self, delegate: self)
            addChild(pdfScrollViewController!)
            pdfScrollViewController!.view.frame = view.frame
            self.view.addSubview(pdfScrollViewController!.view)
        }
    }
    
    private func setPagesPerScreen(forSize size:CGSize) {
        if size.width > size.height && configuration.sideBySideLandscape {
            pdfScrollViewController?.setNumberOfPagesOnScreen(2)
            pagesOnScreen = 2
        }
        else {
            pdfScrollViewController?.setNumberOfPagesOnScreen(1)
            pagesOnScreen = 1
        }
        configurePDFView()
    }
    
    private func showPDFInPDFView(path:String) {
        if #available(iOS 11.0, *) {
            guard let pdfDocument = provider.getPDFDocument(atPath: path) else {return}
            let pdfView = PDFView(frame: containerFrame)
            pdfView.displayDirection = .horizontal
            pdfView.displayMode = .twoUpContinuous
            //pdfView.usePageViewController(true, withViewOptions: nil)
            pdfView.document = pdfDocument
            self.view.addSubview(pdfView)
            self.pdfView = pdfView
            configurePDFView()
        } else {
            print("not available in your iOS version")
        }
    }
    
    private func showPDFInScrollView(path: String) {
        if provider.loadDocument(atPath: path) == false {
            print("coulnd't load document at path \(path)")
            return
        }
        configureScrollViewController()
        setPagesPerScreen(forSize: self.view.frame.size)
        pdfScrollViewController?.loadNewDocument()
        pdfScrollViewController?.gotoPage(1) // pages start from 1
    }
}

// MARK: - GFPDFScrollView

extension GFPDFViewController : GFPDFScrollViewDataSource {
    func numberOfPages() -> Int {
        return provider.numberOfPages()
    }
    
    func viewForPage(atIndex index: Int) -> GFPDFTiledView? {
        guard let page = provider.getPage(atIndex: index) else {
            return nil
        }
        let tiledView = GFPDFTiledView(withFrame: containerFrame, scale: 1.0)
        tiledView.setPage(page)
        return tiledView
    }
}

extension GFPDFViewController : GFPDFScrollViewDelegate {
    func userScrolledToPage(_ page: Int) {
        print("scrolled to page \(page)")
    }
}

//
//  GFPDFViewController.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import UIKit

public class GFPDFViewController: UIViewController {

    var configuration = GFPDFConfiguration()
    private var containerFrame:CGRect {
        return CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
    }
    private var provider = GFPDFDocumentProvider()
    private var pdfScrollViewController:GFPDFScrollViewController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.subviews.count == 0 {
            return
        }
    }
    
    public func showPDF(atPath path:String) {
        if provider.loadDocument(atPath: path) == false {
            print("coulnd't load document at path \(path)")
            return
        }
        configureScrollViewController()
        pdfScrollViewController?.loadNewDocument()
        pdfScrollViewController?.gotoPage(1) // pages start from 1
    }
}

// MARK: - Private

extension GFPDFViewController {
    private func configureScrollViewController() {
        if pdfScrollViewController == nil {
            pdfScrollViewController = GFPDFScrollViewController(configuration: configuration, dataSource: self, delegate: self)
            addChildViewController(pdfScrollViewController!)
            self.view.addSubview(pdfScrollViewController!.view)
        }
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
        tiledView.setPage(page, atIndex:index)
        return tiledView
    }
}

extension GFPDFViewController : GFPDFScrollViewDelegate {
    func userScrolledToPage(_ page: Int) {
        print("scrolled to page \(page)")
    }
}

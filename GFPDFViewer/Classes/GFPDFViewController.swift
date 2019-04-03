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
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setPagesPerScreen(forSize: size)
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
            addChild(pdfScrollViewController!)
            self.view.addSubview(pdfScrollViewController!.view)
        }
    }
    
    private func setPagesPerScreen(forSize size:CGSize) {
        if size.width > size.height && configuration.sideBySideLandscape {
            pdfScrollViewController?.setNumberOfPagesOnScreen(2)
        }
        else {
            pdfScrollViewController?.setNumberOfPagesOnScreen(1)
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
        tiledView.setPage(page)
        return tiledView
    }
}

extension GFPDFViewController : GFPDFScrollViewDelegate {
    func userScrolledToPage(_ page: Int) {
        print("scrolled to page \(page)")
    }
}

//
//  GFPDFViewController.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import UIKit

public class GFPDFViewController: UIViewController {

    var provider = GFPDFDocumentProvider()
    private var containerFrame:CGRect {
        return CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func showPDF(atPath path:String) {
        if provider.loadDocument(atPath: path) == false {
            print("coulnd't load document at path \(path)")
            return
        }
        gotoPage(atIndex: 1) // pages start from 1
    }
    
    @discardableResult public func gotoPage(atIndex index:Int) -> Bool {
        guard let view = getViewForPage(atIndex: index) else {
            return false
        }
        self.view.addSubview(view)
        return true
    }
}

// MARK: - Private

extension GFPDFViewController {
    private func getViewForPage(atIndex index:Int) -> GFPDFTiledView? {
        guard let page = provider.getPage(atIndex: index) else {
            return nil
        }
        let tiledView = GFPDFTiledView(withFrame: containerFrame, scale: 1.0)
        tiledView.setPage(page)
        return tiledView
    }
}

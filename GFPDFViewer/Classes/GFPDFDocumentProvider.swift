//
//  GFPDFDocumentProvider.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import Foundation
import CoreGraphics
import PDFKit

class GFPDFDocumentProvider {
    private var document:CGPDFDocument?
    
    func getPage(atIndex index:Int) -> CGPDFPage? {
        guard let document = document else {return nil}
        return document.page(at:index)
    }
    
    @available(iOS 11.0, *)
    func getPDFDocument(atPath path:String) -> PDFDocument? {
        let url = URL(fileURLWithPath: path)
        return PDFDocument(url: url)
    }
    
    func loadDocument(atPath path:String) -> Bool  {
        guard let url = CFURLCreateWithFileSystemPath(nil, path as CFString, .cfurlposixPathStyle, false) else {
            return false
        }
        document = CGPDFDocument(url)
        return true
    }
    
    func numberOfPages() -> Int {
        guard let document = document else {
            return 0
        }
        return document.numberOfPages
    }
}

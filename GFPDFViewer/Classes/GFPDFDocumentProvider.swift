//
//  GFPDFDocumentProvider.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import Foundation
import CoreGraphics

class GFPDFDocumentProvider {
    private var document:CGPDFDocument?
    
    func getPage(atIndex index:Int) -> CGPDFPage? {
        guard let document = document else {return nil}
        return document.page(at:index)
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

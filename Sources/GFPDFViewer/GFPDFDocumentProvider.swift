//
//  GFPDFDocumentProvider.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import Foundation
import CoreGraphics
import PDFKit

/// Class responsible for handling a PDF document
/// with utility function sto load a document, get the number of pages
/// and return a particular page
class GFPDFDocumentProvider {
    /// Returns the GGPDFPage at the specified index
    /// - Parameter index: page Index
    /// - Returns: A CGPDFPage if found
    func getPage(atIndex index:Int) -> CGPDFPage? {
        guard let document = document else {return nil}
        return document.page(at:index)
    }
    
    /// Returns a PDFDocument at the given path
    /// - Parameter path: The path of the PDF
    /// - Returns: A PDFDocument if found at the given path
    @available(iOS 11.0, *)
    func getPDFDocument(atPath path:String) -> PDFDocument? {
        let url = URL(fileURLWithPath: path)
        return PDFDocument(url: url)
    }
    
    /// Load a GGPDFDocument at the given path
    /// - Parameter path: The path of the PDF
    /// - Returns: true if the document was successfully loaded
    func loadDocument(atPath path:String) -> Bool  {
        guard let url = CFURLCreateWithFileSystemPath(nil, path as CFString, .cfurlposixPathStyle, false) else {
            return false
        }
        document = CGPDFDocument(url)
        return true
    }
    
    /// Returns the number of pages in the document loaded via loadDocument
    /// - Returns: The number of pages, 0 if the document is not found
    func numberOfPages() -> Int {
        guard let document = document else {
            return 0
        }
        return document.numberOfPages
    }
    
    // MARK: - Private
    private var document:CGPDFDocument?
}

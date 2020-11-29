//
//  GFPDFCommon.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 26/03/2019.
//

import Foundation
import UIKit

typealias PDFPage = (page: Int, view: GFPDFTiledView)

/// Struct used to pass parameters to the PDF View controller
public struct GFPDFConfiguration {
    public var backgroundColor = UIColor.white // Scroll view background color
    public var fitPage = true // Fit the entire page on screen. Set false to scroll vertically and fill the page horizontally
    public var sideBySideLandscape = true // Display two pages side-by-side in landscape
    public var scrollVertically = false
    public var usePDFKit = true
    
    public init() {}
}

public protocol GFPDFViewer {
    func resize(toFrame frame:CGRect)
    func setNumberOfPagesOnScreen(_ pages: Int)
}

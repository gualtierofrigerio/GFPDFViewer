//
//  GFPDFCommon.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 26/03/2019.
//

import Foundation
import UIKit

typealias PDFPage = (page: Int, view: GFPDFTiledView)

public struct GFPDFConfiguration {
    public var backgroundColor = UIColor.white // Scroll view background color
    public var sideBySideLandscape = true // Display two pages side-by-side in landscape
    public var fitPage = true // Fit the entire page on screen. Set false to scroll vertically and fill the page horizontally
    public var usePDFKit = true
    
    public init() {}
}

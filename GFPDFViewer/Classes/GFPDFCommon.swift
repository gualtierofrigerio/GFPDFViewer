//
//  GFPDFCommon.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 26/03/2019.
//

import Foundation

struct GFPDFConfiguration {
    var backgroundColor = UIColor.white // Scroll view background color
    var sideBySideLandscape = false // Display two pages side-by-side in landscape
    var fitPage = true // Fit the entire page on screen. Set false to scroll vertically and fill the page horizontally
}

protocol GFPDFScrollViewDataSource {
    func numberOfPages() -> Int
    func viewForPage(atIndex index:Int) -> GFPDFTiledView?
}

protocol GFPDFScrollViewDelegate {
    func userScrolledToPage(_ page:Int)
}


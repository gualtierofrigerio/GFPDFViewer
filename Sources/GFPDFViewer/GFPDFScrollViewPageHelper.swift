//
//  GFPDFScrollViewPageHelper.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 10/04/2019.
//

import Foundation

/// Helper class used by GFPDFScrollViewController
/// to store state information about the PDF currently loaded
class GFPDFScrollViewPageHelper {
    func getIndexesOfPages(onScreen: Int) -> [Int] {
        let startPageIndex = firstPageIndexOnScreen(onScreen)
        var pages = [Int]()
        for i in 0..<pagesOnScreen {
            if startPageIndex + i <= totalNumberOfPages {
                pages.append(startPageIndex + i)
            }
        }
        return pages
    }
    
    func firstPageIndexOnScreen(_ screen: Int) -> Int {
        return (screen * pagesOnScreen) - (pagesOnScreen - 1)
    }
    
    func setNumberOfPagesOnScreen(_ pages: Int) {
        pagesOnScreen = pages
    }
    
    func screenForPage(_ page:Int) -> Int {
        if pagesOnScreen == 0 {
            return 0
        }
        return page / pagesOnScreen + (page % pagesOnScreen)
    }
    
    func setTotalNumberOfPages(_ pages: Int) {
        totalNumberOfPages = pages
    }
    
    // MARK: - Private
    private var pagesOnScreen = 0
    private var totalNumberOfPages = 0
}

//
//  GFPDFScrollViewController.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 26/03/2019.
//

import UIKit

protocol GFPDFScrollViewDataSource {
    func numberOfPages() -> Int
    func viewForPage(atIndex index:Int) -> GFPDFTiledView?
}

protocol GFPDFScrollViewDelegate {
    func userScrolledToPage(_ page:Int)
}

/// ViewController responsible for scrolling pages of a PDF document
/// This VC is compatible with iOS prior to 11 so it is an alternative
/// to PDFKit if you need to support older devices
class GFPDFScrollViewController: UIViewController {
    init(configuration:GFPDFConfiguration,
         dataSource:GFPDFScrollViewDataSource,
         delegate:GFPDFScrollViewDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.configuration = configuration
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        self.view.addSubview(scrollView!)
        scrollView!.addSubview(internalView)
    }
    
    func gotoPage(_ page:Int) {
        adjustContentOffset(forPage: page)
        let pages = pageHelper.getIndexesOfPages(onScreen: page)
        loadPages(pages)
        currentScreen = page
    }
    
    func loadNewDocument() {
        let pages = dataSource.numberOfPages()
        setNumberOfPages(pages: pages)
    }
    
    // MARK: - Private
    
    private var configuration:GFPDFConfiguration!
    private var currentScreen = 0
    private var dataSource:GFPDFScrollViewDataSource!
    private var delegate:GFPDFScrollViewDelegate?
    private var internalView = UIView()
    private var loadedPages = [PDFPage]()
    private var pagesContainerSize:CGSize {
        guard let scrollView = scrollView else {
            return CGSize(width: 0, height: 0)
        }
        return scrollView.frame.size
    }
    private var pageHelper = GFPDFScrollViewPageHelper()
    private var pagesOnScreen = 1
    private var scrollView:UIScrollView?
    private var singlePageWidth:CGFloat {
        return pagesContainerSize.width / CGFloat(pagesOnScreen)
    }
    private var totalNumberOfPages = 0
    private var userIsScrolling = false
    
    private func adjustContentOffset(forPage page:Int) {
        let base0Page = page - 1 // PDF pages start from 1
        let offsetX = CGFloat(base0Page) * pagesContainerSize.width
        scrollView?.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    private func adjustContentSize(numberOfPages:Int) {
        guard let scrollView = scrollView else {return}
        var size = pagesContainerSize
        size.width = singlePageWidth * CGFloat(numberOfPages)
        scrollView.contentSize = size
        internalView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    private func configureScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = configuration.backgroundColor
        scrollView.delegate = self
        scrollView.frame = view.frame
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.bounces = true
        scrollView.bouncesZoom = true
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isMultipleTouchEnabled = true
        scrollView.isPagingEnabled = true
        self.scrollView = scrollView
    }
    
    private func frameForPage(atIndex page:Int) -> CGRect {
        let origin = CGFloat(page - 1) * singlePageWidth
        let frame = CGRect(x: origin, y: 0, width: singlePageWidth, height: pagesContainerSize.height)
        return frame
    }
    
    private func frameForSinglePage(atIndex page:Int) -> CGRect {
        var frame = frameForPage(atIndex: page)
        guard let scrollView = scrollView else {return frame}
        frame.size.width = scrollView.frame.size.width
        return frame
    }
    
    private func loadPage(_ page:Int) {
        loadPages([page])
    }
    
    private func loadPages(_ pages:[Int]) {
        removeLoadedPages()
        for page in pages {
            if let pdfView = dataSource.viewForPage(atIndex: page) {
                var frame:CGRect
                if (pages.count == 1) {
                    frame = frameForSinglePage(atIndex: page)
                }
                else {
                    frame = frameForPage(atIndex: page)
                }
                pdfView.resize(toFrame: frame)
                internalView.addSubview(pdfView)
                loadedPages.append((page, pdfView))
            }
        }
    }
    
    private func removeLoadedPages() {
        for pdfPage in loadedPages {
            pdfPage.view.removeFromSuperview()
        }
        loadedPages.removeAll()
    }
    
    private func resizeViews() {
        resizeTiledViews()
        adjustContentSize(numberOfPages: totalNumberOfPages)
        adjustContentOffset(forPage: currentScreen)
    }
    
    private func resizeTiledViews() {
        for (page,view) in loadedPages {
            let frame = frameForPage(atIndex: page)
            view.resize(toFrame: frame)
        }
    }
    
    private func setNumberOfPages(pages:Int) {
        totalNumberOfPages = pages
        adjustContentSize(numberOfPages: pages)
        pageHelper.setTotalNumberOfPages(pages)
    }
}

// MARK: - GFPDFViewer protocol

extension GFPDFScrollViewController : GFPDFViewer {
    func resize(toFrame frame:CGRect) {
        scrollView?.frame = frame
        resizeViews()
    }
    
    func setNumberOfPagesOnScreen(_ pages:Int) {
        let currentPage = pageHelper.firstPageIndexOnScreen(currentScreen)
        pageHelper.setNumberOfPagesOnScreen(pages)
        let screen = pageHelper.screenForPage(currentPage)
        pagesOnScreen = pages
        gotoPage(screen)
        resizeViews()
    }
}

// MARK: - ScrollViewDelegate

extension GFPDFScrollViewController : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userIsScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        userIsScrolling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screen = (Int)(scrollView.contentOffset.x / pagesContainerSize.width) + 1
        if screen != currentScreen && userIsScrolling {
            currentScreen = screen
            let pages = pageHelper.getIndexesOfPages(onScreen: currentScreen)
            loadPages(pages)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return internalView
    }
}

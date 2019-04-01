//
//  GFPDFScrollViewController.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 26/03/2019.
//

import UIKit

class GFPDFScrollViewController: UIViewController {

    private var configuration:GFPDFConfiguration!
    private var currentPage = 0
    private var dataSource:GFPDFScrollViewDataSource!
    private var delegate:GFPDFScrollViewDelegate?
    private var numberOfPages = 0
    private var pageWidth:CGFloat {
        return scrollView.frame.size.width
    }
    private var scrollView:UIScrollView!
    private var userIsScrolling = false
    
    init(configuration:GFPDFConfiguration, dataSource:GFPDFScrollViewDataSource, delegate:GFPDFScrollViewDelegate?) {
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
        self.view.addSubview(scrollView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("viewWillTransition")
        scrollView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        resizeTiledViews()
        adjustContentSize(numberOfPages: numberOfPages)
        adjustContentOffset(forPage: currentPage)
    }
    
    func gotoPage(_ page:Int) {
        adjustContentOffset(forPage: page)
        loadPage(page)
    }
    
    func loadNewDocument() {
        let pages = dataSource.numberOfPages()
        setNumberOfPages(pages: pages)
    }
}

// MARK: - Private

extension GFPDFScrollViewController {
    
    private func adjustContentOffset(forPage page:Int) {
        let base0Page = page - 1 // PDF pages start from 1
        let offsetX = CGFloat(base0Page) * pageWidth
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    private func adjustContentSize(numberOfPages:Int) {
        var size = scrollView.frame.size
        size.width = size.width * CGFloat(numberOfPages)
        scrollView.contentSize = size
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
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
    }
    
    private func frameOriginForPage(atIndex page:Int) -> CGFloat {
        let origin = CGFloat(page - 1) * scrollView.frame.size.width
        return origin
    }
    
    private func loadPage(_ page:Int) {
        guard let pdfView = dataSource.viewForPage(atIndex: page) else {return}
        var frame = pdfView.frame
        frame.origin.x = frameOriginForPage(atIndex: page)
        pdfView.frame = frame
        scrollView.addSubview(pdfView)
    }
    
    private func resizeTiledViews() {
        for view in scrollView.subviews {
            if let tiledView = view as? GFPDFTiledView {
                tiledView.resize(toFrame: scrollView.frame)
                var frame = scrollView.frame
                frame.origin.x = frameOriginForPage(atIndex: tiledView.pageIndex)
                tiledView.frame = frame
            }
        }
    }
    
    private func setNumberOfPages(pages:Int) {
        numberOfPages = pages
        adjustContentSize(numberOfPages: pages)
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
        let page = (Int)(scrollView.contentOffset.x / pageWidth) + 1
        if page != currentPage && userIsScrolling {
            currentPage = page
            print("scrollViewDidScroll currentPage = \(currentPage)")
            loadPage(page)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.subviews.count > 0 {
            return scrollView.subviews[0]
        }
        return nil
    }
}

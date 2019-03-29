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
    private var pageWidth:CGFloat {
        return scrollView.frame.size.width
    }
    private var scrollView:UIScrollView!
    
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

    override func viewWillLayoutSubviews() {
        scrollView.frame = self.view.bounds
        guard let tiledView = scrollView.subviews[0] as? GFPDFTiledView else {return}
        tiledView.frame = self.view.bounds
        tiledView.resize(toFrame: self.view.bounds)
    }
    
    func gotoPage(_ page:Int) {
        let base0Page = page - 1 // PDF pages start from 1
        let offsetX = CGFloat(base0Page) * pageWidth
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        loadPage(page)
    }
    
    func loadNewDocument() {
        let pages = dataSource.numberOfPages()
        setNumberOfPages(pages: pages)
    }
}

// MARK: - Private

extension GFPDFScrollViewController {
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
    
    private func loadPage(_ page:Int) {
        guard let pdfView = dataSource.viewForPage(atIndex: page) else {return}
        scrollView.addSubview(pdfView)
    }
    
    private func setNumberOfPages(pages:Int) {
        var size = scrollView.frame.size
        size.width = size.width * CGFloat(pages)
        scrollView.contentSize = size
    }
}

// MARK: - ScrollViewDelegate

extension GFPDFScrollViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = (Int)(scrollView.contentOffset.x / pageWidth) + 1
        if page != currentPage {
            currentPage = page
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

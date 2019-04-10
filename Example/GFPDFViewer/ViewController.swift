//
//  ViewController.swift
//  GFPDFViewer
//
//  Created by gualtierofrigerio on 03/13/2019.
//  Copyright (c) 2019 gualtierofrigerio. All rights reserved.
//

import UIKit
import GFPDFViewer

class ViewController: UIViewController {
    
    @IBOutlet weak var pdfView: UIView!
    
    var pdfViewController:GFPDFViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { (context) in
            var frame = self.pdfView.frame
            frame.origin = CGPoint(x: 0, y: 0)
            self.pdfViewController?.resize(toFrame:frame)
        }
    }
    
    @IBAction func loadButtonTap(_ sender: Any) {
        guard let pdfPath = Bundle.main.path(forResource: "test2", ofType: "pdf", inDirectory: "pdfs") else {return}
        var configuration = GFPDFConfiguration()
        configuration.sideBySideLandscape = true
       
        let pdfViewer = GFPDFViewController(withConfiguration: configuration)
        pdfView.addSubview(pdfViewer.view)
        self.addChild(pdfViewer)
        pdfViewer.didMove(toParent: self)
        pdfViewer.showPDF(atPath: pdfPath)
        
        var frame = pdfView.frame
        frame.origin = CGPoint(x: 0, y: 0)
        pdfViewer.resize(toFrame:frame)
        
        pdfViewController = pdfViewer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


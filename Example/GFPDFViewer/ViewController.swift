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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loadButtonTap(_ sender: Any) {
        guard let pdfPath = Bundle.main.path(forResource: "sample", ofType: "pdf", inDirectory: "pdfs") else {return}
        var configuration = GFPDFConfiguration()
        configuration.sideBySideLandscape = true
        let pdfViewer = GFPDFViewController(withConfiguration: configuration)
        pdfViewer.showPDF(atPath: pdfPath)
        self.addChild(pdfViewer)
        pdfView.addSubview(pdfViewer.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


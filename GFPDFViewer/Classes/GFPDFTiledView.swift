//
//  GFPDFTiledView.swift
//  GFPDFViewer
//
//  Created by Gualtiero Frigerio on 13/03/2019.
//

import UIKit

class GFPDFTiledView: UIView {
    
    override class var layerClass: AnyClass {
        return CATiledLayer.self
    }
    
    private var scale:CGFloat = 1.0
    private var page:CGPDFPage?
    private var currentFrame:CGRect!

    init(withFrame frame: CGRect, scale:CGFloat) {
        super.init(frame: frame)
        
        self.scale = scale
        let tiledLayer = self.layer as! CATiledLayer
        tiledLayer.levelsOfDetail = 3
        tiledLayer.levelsOfDetailBias = 3
        tiledLayer.tileSize = CGSize(width: 1024, height: 1024)
        tiledLayer.shouldRasterize = false
        tiledLayer.borderColor = UIColor.lightGray.cgColor
        tiledLayer.borderWidth = 0
        currentFrame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resize(toFrame frame:CGRect) {
        self.frame = frame
        currentFrame = CGRect(x:0, y:0, width: frame.size.width, height:frame.size.height)
        let tiledLayer = self.layer as! CATiledLayer
        tiledLayer.setNeedsDisplay()
    }
    
    func setPage(_ page:CGPDFPage) {
        self.page = page
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        // Fill the background with white.
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(currentFrame)
        
        guard let page = self.page else {return}
        
        let box = page.getBoxRect(.mediaBox)
        let (xScale, yScale, xTranslate, yTranslate) = getTranslationAndScale(forRect: currentFrame, box: box)
        
        let xScaleA = xScale * scale
        let yScaleA = yScale * scale
        
        ctx.translateBy(x: xTranslate, y: yTranslate)
        ctx.scaleBy(x: xScaleA, y: yScaleA)
        ctx.saveGState()
        // Flip the context so that the PDF page is rendered right side up.
        ctx.translateBy(x: 0.0, y: currentFrame.size.height / yScaleA)
        ctx.scaleBy(x: 1.0, y: -1.0)
        //let transform = page.getDrawingTransform (.mediaBox, rect: self.bounds, rotate: 0, preserveAspectRatio: true)
        ctx.saveGState()
        // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
        ctx.scaleBy(x: scale, y: scale)
        ctx.clip(to: box)
        ctx.drawPDFPage(page)
        ctx.restoreGState()
    }

}

// MARK: - Private

extension GFPDFTiledView {
    func getTranslationAndScale(forRect rect:CGRect, box:CGRect) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let rectRatio = rect.size.width / rect.size.height
        let boxRatio = box.size.width / box.size.height;
        let widthRatio = rect.size.width / box.size.width;
        let heightRatio = rect.size.height / box.size.height;
        
        var xScale:CGFloat = 1.0
        var yScale:CGFloat = 1.0
        var xTranslate:CGFloat = 0.0
        var yTranslate:CGFloat = 0.0
        
        if (rectRatio > 1)
        {
            if (boxRatio > 1)
            {
                xScale = rect.size.width / box.size.width
                yScale = rect.size.height / box.size.height
            }
            else
            {
                yScale = rect.size.height / box.size.height
                
                var newSize = CGSize()
                newSize.height = box.size.height * yScale
                newSize.width = newSize.height * boxRatio
                
                //xScale = widthRatio > 1 ? 1 : newSize.width / box.size.width;
                xScale = newSize.width / box.size.width
                
                xTranslate = (rect.size.width - newSize.width) / 2
            }
        }
        else
        {
            if (boxRatio < 1)
            {
                xScale = rect.size.width / box.size.width
                yScale = rect.size.height / box.size.height
            }
            else
            {
                xScale = widthRatio > 1 ? 1 : rect.size.width / box.size.width
                
                var newSize = CGSize()
                newSize.width = box.size.width * xScale
                newSize.height = newSize.width / boxRatio
                
                yScale = heightRatio > 1 ? 1 : newSize.height / box.size.height
                
                xTranslate = (rect.size.width - newSize.width) / 2
                //yTranslate = (rect.size.height - newSize.height) / 2
            }
        }
        
        return (xScale, yScale, xTranslate, yTranslate)
    }
}

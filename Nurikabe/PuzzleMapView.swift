//
//  PuzzleMapView.swift
//  Nurikabe
//
//  Created by JIAWEI CHEN on 7/27/17.
//  Copyright © 2017 Pokgear Inc. All rights reserved.
//

import UIKit

fileprivate enum RetangleValue {
    case black
    case white
    case value(Int)
}

class PuzzleMapLayer: CAShapeLayer {
    var rows: Int = 0 {
        didSet {
            updateMap()
        }
    }
    var colums: Int = 0 {
        didSet {
            updateMap()
        }
    }
    
    override var lineWidth: CGFloat {
        didSet {
            updatePath()
            setNeedsDisplay()
        }
    }
    
    override var strokeColor: CGColor? {
        didSet {
            updatePath()
            setNeedsDisplay()
        }
    }
    
    private var textFont: UIFont!
    
    override init() {
        super.init()
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        fillColor = UIColor.black.cgColor
        strokeColor = UIColor.black.cgColor
        textFont = UIDevice.current.userInterfaceIdiom == .pad ? UIFont.systemFont(ofSize: 38.0) : UIFont.systemFont(ofSize: 28.0)
    }
    
    
    fileprivate var rowPoints = [CGFloat]()
    fileprivate var columPoints = [CGFloat]()
    fileprivate var retangles = [RetangleValue]()
    
    private func retangleFrame(at index: Int) -> CGRect {
        guard rows > 0 && colums > 0 else {
            return CGRect()
        }
        let i = index / colums
        let j = index % colums
        
        let frame = self.bounds
        let width = frame.size.width - lineWidth/2
        let height = frame.size.height - lineWidth/2
        
        return CGRect(x: CGFloat(j) * width/CGFloat(colums), y: CGFloat(i) * height/CGFloat(rows), width: width/CGFloat(colums), height: height/CGFloat(rows))
    }
    
    private func updatePoints() {
        rowPoints.removeAll()
        columPoints.removeAll()
        if rows == 0 || colums == 0 {
            return
        }
        
        let width = bounds.size.width - lineWidth/2
        let height = bounds.size.height - lineWidth/2
        
        rowPoints.append(0)
        for i in stride(from: lineWidth/2, through: height, by: height/CGFloat(rows)) {
            rowPoints.append(i)
        }
        rowPoints.append(height + lineWidth/2)
        
        columPoints.append(0)
        for i in stride(from: lineWidth/2, through: width, by: width/CGFloat(colums)) {
            columPoints.append(i)
        }
        columPoints.append(width + lineWidth/2)
    }
    
    fileprivate func updatePath() {
        let width = bounds.size.width
        let height = bounds.size.height
        let linePath = UIBezierPath();
        for y in rowPoints {
            linePath.move(to: CGPoint(x: 0, y: y))
            linePath.addLine(to: CGPoint(x: width, y: y))
        }
        for x in columPoints {
            linePath.move(to: CGPoint(x: x, y: 0))
            linePath.addLine(to: CGPoint(x: x, y: height))
        }
        
        // retangles
        for i in 0..<retangles.count {
            let retangle = retangles[i]
            let frame = retangleFrame(at: i)
            let retanglePath = UIBezierPath(rect: frame)
            switch retangle {
            case .black:
                retanglePath.fill()
                linePath.append(retanglePath)
            default:
                break
            }
        }
        
        path = linePath.cgPath
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        
        for i in 0..<retangles.count {
            let retangle = retangles[i]
            let frame = retangleFrame(at: i)
            switch retangle {
            case .value(let num):
                let label = UILabel(frame: frame)
                label.font = textFont
                label.baselineAdjustment = .alignCenters
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = .center
                label.text = String(num)
                label.drawText(in: frame)
            default:
                break
            }
        }
        UIGraphicsPopContext()
        
    }
    
    func updateMap() {
        updatePoints()
        updatePath()
        setNeedsDisplay()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        updateMap()
    }
    
    func retangleIndex(at pos: CGPoint) -> Int {
        
        debugPrint("tap pos: \(pos)")
        let width = bounds.size.width - lineWidth/2
        let height = bounds.size.height - lineWidth/2
        //debugPrint("width=\(height/CGFloat(rows)), height=\(width/CGFloat(colums))")
        let i = Int((pos.y - lineWidth/2) / (height/CGFloat(rows)))
        let j = Int((pos.x - lineWidth/2) / (width/CGFloat(colums)))
        debugPrint("(\(i), \(j))")
        return i * colums + j
    }
    
}


@IBDesignable class PuzzleMapView: UIView {
    override class var layerClass: AnyClass {
        return PuzzleMapLayer.self
    }
    
    var puzzleLayer: PuzzleMapLayer {
        return self.layer as! PuzzleMapLayer
    }
    
    private var _rows = 0
    @IBInspectable var rows: Int {
        get { return puzzleLayer.rows }
        set { puzzleLayer.rows = newValue }
    }
    
    private var _colums = 0
    @IBInspectable var colums: Int {
        get { return puzzleLayer.colums }
        set { puzzleLayer.colums = newValue }
    }
    
    @IBInspectable var lineWidth: CGFloat {
        get { return puzzleLayer.lineWidth }
        set { puzzleLayer.lineWidth = newValue }
    }
    
    @IBInspectable var lineColor: CGColor? {
        get { return puzzleLayer.strokeColor }
        set { puzzleLayer.strokeColor = newValue }
    }
    
    var puzzleArray: [[Int]]! {
        didSet {
            rows = puzzleArray.count
            if rows > 0 {
                colums = puzzleArray[0].count
            }
            else {
                colums = 0
            }
            // update layers retangles
            puzzleLayer.retangles.removeAll()
            for arr in puzzleArray {
                for a in arr {
                    if a == -1 {
                        puzzleLayer.retangles.append(.black)
                    }
                    else if a == 0 {
                        puzzleLayer.retangles.append(.white)
                    }
                    else {
                        puzzleLayer.retangles.append(.value(a))
                    }
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGR)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // handling code
            let pos = sender.location(in: self)
            let index = puzzleLayer.retangleIndex(at: pos)
            
            let value = puzzleArray[index/colums][index % colums]
            if value > 0 {
                return
            }
            if value == -1 {
                puzzleArray[index/colums][index % colums] = 0
                puzzleLayer.retangles[index] = .white
            }
            else {
                puzzleArray[index/colums][index % colums] = -1
                puzzleLayer.retangles[index] = .black
            }
            puzzleLayer.updatePath()
            puzzleLayer.setNeedsDisplay()
        }
    }

}


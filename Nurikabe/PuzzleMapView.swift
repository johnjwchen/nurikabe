//
//  PuzzleMapView.swift
//  Nurikabe
//
//  Created by JIAWEI CHEN on 7/27/17.
//  Copyright © 2017 Pokgear Inc. All rights reserved.
//

import UIKit

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
    
    override init() {
        super.init()
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        strokeColor = UIColor.black.cgColor
    }
    
    
    fileprivate var rowPoints = [CGFloat]()
    fileprivate var columPoints = [CGFloat]()
    
    private func updatePoints() {
        rowPoints.removeAll()
        columPoints.removeAll()
        if rows == 0 || colums == 0 {
            return
        }
        let frame = self.bounds
        let width = frame.size.width - lineWidth/2
        let height = frame.size.height - lineWidth/2
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
    
    private func updatePath() {
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
        path = linePath.cgPath
    }
    
    func updateMap() {
        updatePoints()
        updatePath()
        setNeedsDisplay()
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
        }
    }

}


//
//  MapViewTests.swift
//  Nurikabe
//
//  Created by JIAWEI CHEN on 7/31/17.
//  Copyright © 2017 Pokgear Inc. All rights reserved.
//

import XCTest
@testable import Nurikabe


class MockTap: UITapGestureRecognizer {
    var location: CGPoint!
    init(withLocation location: CGPoint) {
        super.init(target: nil, action: nil)
        self.location = location
        let value = NSNumber(value: UIGestureRecognizerState.ended.rawValue)
        setValue(value, forKey: "state")
    }
    
    override func location(in view: UIView?) -> CGPoint {
        return location
    }
}

class MapViewTests: XCTestCase {
    
    var viewController: ViewController! = nil
    var mapView: PuzzleMapView {
        get {
            return viewController.puzzleMapView
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewController = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self)).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        XCTAssertNotNil(viewController.view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapViewNotNil() {
        XCTAssertNotNil(mapView)
    }
    
    func testEmptyPuzzleArray() {
        mapView.puzzleArray = []
        XCTAssertNotNil(mapView)
    }
    
    func testMapViewToggle() {
        mapView.puzzleArray = [[0]]
        let gestureRecognizer = UITapGestureRecognizer()
        let value = NSNumber(value: UIGestureRecognizerState.ended.rawValue)
        gestureRecognizer.setValue(value, forKey: "state")
        
        mapView.handleTap(sender: gestureRecognizer)
        XCTAssertEqual(mapView.puzzleArray[0][0], -1)
        
        mapView.handleTap(sender: gestureRecognizer)
        XCTAssertEqual(mapView.puzzleArray[0][0], 0)
    }
    
    func testMapViewNotTouchOnNumberCell() {
        mapView.puzzleArray = [[10]]
        let gestureRecognizer = UITapGestureRecognizer()
        let value = NSNumber(value: UIGestureRecognizerState.ended.rawValue)
        gestureRecognizer.setValue(value, forKey: "state")
        
        mapView.handleTap(sender: gestureRecognizer)
        XCTAssertEqual(mapView.puzzleArray[0][0], 10)
    }
    
    func testMapViewToggleWithMoreCells() {
        mapView.puzzleArray = [[0,0],[2,0]]
        mapView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let tap1 = MockTap(withLocation: CGPoint(x: 80, y: 10))
        mapView.handleTap(sender: tap1)
        XCTAssertEqual(mapView.puzzleArray[0][1], -1)
        
        let tap0 = MockTap(withLocation: CGPoint(x: 10, y: 10))
        mapView.handleTap(sender: tap0)
        XCTAssertEqual(mapView.puzzleArray[0][0], -1)
        
        mapView.handleTap(sender: tap0)
        XCTAssertEqual(mapView.puzzleArray[0][0], 0)
        
    }
    
    func testMapViewGridPrecise() {
        mapView.puzzleArray = [[0,0],[2,0]]
        mapView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let tap2 = MockTap(withLocation: CGPoint(x: 51, y: 49))
        mapView.handleTap(sender: tap2)
        XCTAssert(mapView.puzzleArray[1][0] == 2, "Number cell should not be touchable.")
        
        let tap3 = MockTap(withLocation: CGPoint(x: 51, y: 51))
        mapView.handleTap(sender: tap3)
        XCTAssert(mapView.puzzleArray[1][1] == -1, "Map view grid is not drawed properly.")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

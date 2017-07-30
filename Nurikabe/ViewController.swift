//
//  ViewController.swift
//  Nurikabe
//
//  Created by JIAWEI CHEN on 7/26/17.
//  Copyright © 2017 Pokgear Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var puzzleMapView: PuzzleMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // test
        puzzleMapView.puzzleArray = [
            [2, 0, 0, 0, 0, 6],
            [0, 0, 0, 0, 0, 0],
            [0, 1, 0, 2, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [3, 0, 0, 0, 0, 0],
            [0, 0, 0, 1, 0, 2],
            [0, 0, 0, 0, 0, 0],
            [1, 0, 0, 0, 0, 0],
            [0, 0, 3, 0, 0, 1]
        ]
    }



}


//
//  VitalsViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 03/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit
import Foundation

var glucoseLevel:Double = -1
var insulinLevel:Double = -1
// , BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate
class VitalsViewController: UIViewController, BEMSimpleLineGraphDelegate{
    @IBOutlet weak var insulinLabel: UILabel!
    @IBOutlet weak var glucoseLabel: UILabel!

    @IBOutlet weak var myGraph: BEMSimpleLineGraphView!
    var timer = NSTimer()
    
    var glucoseLevels:NSMutableArray = []
    var insulinLevels:NSMutableArray = []
    var time:NSMutableArray = []
    
    var previousStepperValue:Int = 0
    var totalNumber:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraph()
        hydrateValues()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("generateLevels"), userInfo: nil, repeats: true)
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return glucoseLevels.count
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(glucoseLevels.objectAtIndex(index) as! NSNumber)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGraph() {
        myGraph.animationGraphEntranceTime = 0
    }
    
    func generateLevels() {
        glucoseLevels.removeObjectAtIndex(0)
        
        glucoseLevel = cos(Double(Int(arc4random_uniform(10)))) + 1
        insulinLevel = sin(Double(Int(arc4random_uniform(10)))) + 1
        
        glucoseLevels.addObject(glucoseLevel)
        
        glucoseLabel.text = String(format: "%.5f", glucoseLevel)
        insulinLabel.text = String(format: "%.5f", insulinLevel)
        
        myGraph.reloadGraph()
    }

    func hydrateValues() {
        glucoseLevels.removeAllObjects()
        insulinLevels.removeAllObjects()
        time.removeAllObjects()
        
        
        previousStepperValue = 1;
        totalNumber = 0;
        var showNullValue = true;
        
        // Add objects to the array based on the stepper value
        for(var i=0; i < 100; i++){
            glucoseLevels.addObject(0)
            time.addObject(i)
            totalNumber = totalNumber + Int(glucoseLevels.objectAtIndex(i) as! NSNumber)
        }
    }
}

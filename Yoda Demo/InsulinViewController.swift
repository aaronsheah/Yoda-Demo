//
//  InsulinViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 02/06/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

class InsulinViewController: UIViewController,BEMSimpleLineGraphDelegate {
    
    var time:NSMutableArray = []
    var n_values:Int = 0
    
    var insuGraphRefreshTimer = NSTimer()
    
    @IBOutlet weak var insuLabel: UILabel!
    
    @IBOutlet weak var insuGraph: BEMSimpleLineGraphView!
    
    @IBOutlet weak var lastNSegmentedControl: UISegmentedControl!
    @IBAction func lastNValueChanged(sender: AnyObject) {
        n_values = lastNSegmentedControl.selectedSegmentIndex
        
        // refresh graph values
        insuGraph.reloadGraph()
    }
    
    @IBAction func clearValues(sender: AnyObject) {
        glucoseLevels.removeAllObjects()
        insulinLevels.removeAllObjects()
        
        // Amount of 5 minute intervals in a day
        var capacity = 24 * 60 / 5
        // Initialise array
        for x in 0...capacity-1 {
            insulinLevels.addObject(0 as Float)
            glucoseLevels.addObject(0 as Float)
        }
        
        insuGraph.reloadGraph()
    }

    func playButtonPressed() {
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        
        if !timerSet {
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshValues"), userInfo: nil, repeats: true)
            timerSet = true
        }
        
        insuGraphRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshInsuGraph"), userInfo: nil, repeats: true)
        self.navigationItem.setRightBarButtonItem(buttonPause, animated: true)
    }
    func pauseButtonPressed() {
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        if timerSet {
            timer.invalidate()
            timerSet = false
        }
        
        insuGraphRefreshTimer.invalidate()
        self.navigationItem.setRightBarButtonItem(buttonPlay, animated: true)
    }
    
    /*******************************/
    /*** View Controller Methods ***/
    /*******************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Amount of 5 minute intervals in a day
        var capacity = 24 * 60 / 5
        // Initialise array
        if time.count == 0 {
            for x in 0...capacity-1 {
                time.addObject(capacity-x as Int)
            }    
        }

        if glucoseLevels.count == 0 {
            for x in 0...capacity-1 {
                glucoseLevels.addObject(0 as Float)
            }    
        }

        if insulinLevels.count == 0 {
            for x in 0...capacity-1 {
                insulinLevels.addObject(0 as Float)
            }    
        }

        setupGraph()
        
    }

    override func viewDidAppear(animated: Bool) {
        
        /*** Setup top right button to be Play/Pause ***/
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        var topRightButton:UIBarButtonItem = UIBarButtonItem()
        
        // timer not set = Ready to Play
        if timerSet == false {
            topRightButton = buttonPlay
            insuGraphRefreshTimer.invalidate()
        }
        else {
            topRightButton = buttonPause
            
            if !insuGraphRefreshTimer.valid {
                insuGraphRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshInsuGraph"), userInfo: nil, repeats: true)
            }
        }
        self.navigationItem.setRightBarButtonItem(topRightButton, animated: false)
        
        insuGraph.reloadGraph()
    }
    
    /*******************************/
    /*** Graph Methods ***/
    /*******************************/
    func refreshInsuGraph() {
        insuGraph.reloadGraph()
        
        refreshLabel()
    }
    
    func refreshLabel() {
        let insu = NSString(format: "%.1f", insulinLevels.lastObject as! Float)
        
        insuLabel.text = "\(insu)"
    }
    
    func setupGraph() {
        insuGraph.enableYAxisLabel = true
        insuGraph.autoScaleYAxis = true
        
        insuGraph.enableReferenceAxisFrame = true
        
        insuGraph.enableXAxisLabel = true
        insuGraph.animationGraphEntranceTime = 0.5
        insuGraph.enablePopUpReport = true
        insuGraph.enableTouchReport = true
        
        insuGraph.formatStringForValues = "%.1f"
    }

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph === insuGraph {
            if n_values == 0 {
                // 3 hrs
                return 3 * 60 / 5
            }
            else if n_values == 1 {
                // 6 hrs
                return 6 * 60 / 5
            }
            else if n_values == 2 {
                // 12 hrs
                return 12 * 60 / 5
            }
            else if n_values == 3 {
                // 24 hrs
                return 24 * 60 / 5
            }
            return insulinLevels.count
        }
        else {
            return 0
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        if graph == insuGraph {
            if n_values == 0 {
                // 3 hrs
                return CGFloat(insulinLevels.objectAtIndex(index + 251) as! NSNumber)
            }
            else if n_values == 1 {
                // 6 hrs
                return CGFloat(insulinLevels.objectAtIndex(index + 215) as! NSNumber)
            }
            else if n_values == 2 {
                // 12 hrs
                return CGFloat(insulinLevels.objectAtIndex(index + 143) as! NSNumber)
            }
            else if n_values == 3 {
                // 24 hrs
                return CGFloat(insulinLevels.objectAtIndex(index) as! NSNumber)
            }
            return CGFloat(insulinLevels.objectAtIndex(index) as! NSNumber)
        }
        else {
            return 0
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        if n_values == 0 {
            // 3 hrs
            return "-\(175 - index*5)"
        }
        else if n_values == 1 {
            // 6 hrs
            return "-\(360 - index*5)"
        }
        else if n_values == 2 {
            // 12 hrs
            return "-\(720 - index*5)"
        }
        else if n_values == 3 {
            // 24 hrs
            return "-\(1440 - index*5)"
        }
        return ""
    }
    
    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph === insuGraph {
            if n_values == 0 {
                // 3 hrs
                return 5
            }
            else if n_values == 1 {
                // 6 hrs
                return 12
            }
            else if n_values == 2 {
                // 12 hrs
                return 12
            }
            else if n_values == 3 {
                // 24 hrs
                return 12
            }
        }
        return 0
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return 0
    }
    
    /*** Get New Values ***/
    func refreshValues() {
        if bt {
            var inbox = NSArray(array: inboxGI)
            inboxGI.removeAllObjects()
            return
        }
        var api = "https://ic-yoda.appspot.com/_ah/api/icYodaApi/v1/glucInsuValues"
        var request = NSMutableURLRequest(URL: NSURL(string: api)!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        var params = [String:String]()
        // Only take latest 5 values
        params["n"] = "5"
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            if error != nil {
                println(error)
            }
            if data == nil {
                return
            }
            var json = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var items = parseJSON["items"] as! NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                        for item in items {
                            var date = item["date"] as! String
                            if  date > startDateTime && date > lastValueDate {
                                let gluc = (item["gluc"] as! NSString).floatValue
                                glucoseLevels.removeObjectAtIndex(0)
                                glucoseLevels.addObject(gluc)
                                
                                let insu = (item["insu"] as! NSString).floatValue
                                insulinLevels.removeObjectAtIndex(0)
                                insulinLevels.addObject(insu)
                                
                                lastValueDate = date
                            }
                        }
                    }
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
}

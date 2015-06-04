//
//  GlucoseViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 28/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

class GlucoseViewController: UIViewController, BEMSimpleLineGraphDelegate {
    
    var time:NSMutableArray = []
    var n_values:Int = 0
    var counter = 0
    var glucGraphRefreshTimer = NSTimer()
    
    @IBOutlet weak var glucLabel: UILabel!
    
    @IBOutlet weak var lastNSegmentedControl: UISegmentedControl!
    @IBAction func lastNValueChanged(sender: AnyObject) {
        n_values = lastNSegmentedControl.selectedSegmentIndex
        
        glucGraph.reloadGraph()
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
        
        glucGraph.reloadGraph()
    }
    
    @IBOutlet weak var glucGraph: BEMSimpleLineGraphView!
    
    func playButtonPressed() {
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        
        if !timerSet {
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshValues:"), userInfo: nil, repeats: true)
            timerSet = true
        }
        glucGraphRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshGlucGraph"), userInfo: nil, repeats: true)
        self.navigationItem.setRightBarButtonItem(buttonPause, animated: true)
    }
    func pauseButtonPressed() {
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        if timerSet {
            timer.invalidate()
            timerSet = false
        }
        glucGraphRefreshTimer.invalidate()
        self.navigationItem.setRightBarButtonItem(buttonPlay, animated: true)
    }
    
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
        
        // Get the start of Simulation time
        if(startDateTime == "") {
            var components = NSString(string: "\(NSDate())").componentsSeparatedByString(" ")
            startDateTime = "\(components[0])&\(components[1])"
            lastValueDate = startDateTime
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        glucGraph.reloadGraph()
        
        /*** Setup top right button to be Play/Pause ***/
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        var topRightButton:UIBarButtonItem = UIBarButtonItem()
        
        // timer not set = Ready to Play
        if timerSet == false {
            topRightButton = buttonPlay
            glucGraphRefreshTimer.invalidate()
        }
        else {
            topRightButton = buttonPause
            
            if !glucGraphRefreshTimer.valid {
                glucGraphRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshGlucGraph"), userInfo: nil, repeats: true)
            }
        }
        self.navigationItem.setRightBarButtonItem(topRightButton, animated: false)
        
    }
    
    func refreshGlucGraph() {
        glucGraph.reloadGraph()
    }
    
    func setupGraph() {
        
        var minGluc = BEMAverageLine()
        minGluc.yValue = 3
        minGluc.enableAverageLine = true
        minGluc.color = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
        minGluc.dashPattern = [10]
        
        var maxGluc = BEMAverageLine()
        maxGluc.yValue = 10
        maxGluc.enableAverageLine = true
        maxGluc.color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        maxGluc.dashPattern = [10]
        
        glucGraph.minRefLine = minGluc
        glucGraph.maxRefLine = maxGluc
        
        glucGraph.enableYAxisLabel = true
        glucGraph.autoScaleYAxis = true
        
        glucGraph.enableReferenceAxisFrame = true
        
        glucGraph.enableXAxisLabel = true
        glucGraph.animationGraphEntranceTime = 0.5
        glucGraph.enablePopUpReport = true
        glucGraph.enableTouchReport = true
        
        glucGraph.formatStringForValues = "%.2f"
    }

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph == glucGraph {
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
            return glucoseLevels.count
        }
        else {
            return 0
        }
    }

    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        
        if graph === glucGraph {
            if n_values == 0 {
                // 3 hrs
                return CGFloat(glucoseLevels.objectAtIndex(index + 251) as! NSNumber)
            }
            else if n_values == 1 {
                // 6 hrs
                return CGFloat(glucoseLevels.objectAtIndex(index + 215) as! NSNumber)
            }
            else if n_values == 2 {
                // 12 hrs
                return CGFloat(glucoseLevels.objectAtIndex(index + 143) as! NSNumber)
            }
            else if n_values == 3 {
                // 24 hrs
                return CGFloat(glucoseLevels.objectAtIndex(index) as! NSNumber)
            }
            return CGFloat(glucoseLevels.objectAtIndex(index) as! NSNumber)
        }
        else {
            return 0
        }
    }

    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        if graph === glucGraph {
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
        }
        return ""
    }
    
    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph === glucGraph {
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
    
//    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
//        return 15
//    }
    
    func refreshLabel() {
        let gluc = NSString(format: "%.2f", glucoseLevels.lastObject as! Float)
        glucLabel.text = "\(gluc)"
    }
    
    func drawGraph(items:NSArray) {
        
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
        refreshLabel()
        glucGraph.reloadGraph()
    }
    
    @IBAction func refreshValues(sender: AnyObject) {
        if bt {
            var inbox = NSArray(array: inboxGI)
            inboxGI.removeAllObjects()
            drawGraph(inbox)
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

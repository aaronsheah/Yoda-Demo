//
//  Vitals2ViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 21/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

var glucoseLevels:NSMutableArray = []
var insulinLevels:NSMutableArray = []

var startDateTime:String = ""
var lastValueDate = ""

var inboxGI:NSMutableArray = []
var timerSet = false
var timer = NSTimer()

class Vitals2ViewController: UIViewController, BEMSimpleLineGraphDelegate {
    var graphRefreshTimer = NSTimer()

    var time:NSMutableArray = []
    var n_values:Int = 0
    
    @IBOutlet weak var glucLabel: UILabel!
    @IBOutlet weak var insuLabel: UILabel!
    @IBOutlet weak var glucGraph: BEMSimpleLineGraphView!
    @IBOutlet weak var insuGraph: BEMSimpleLineGraphView!
    
    @IBOutlet weak var lastNSegmentedControl: UISegmentedControl!
    @IBAction func lastNValueChanged(sender: AnyObject) {
        n_values = lastNSegmentedControl.selectedSegmentIndex

        glucGraph.reloadGraph()
        insuGraph.reloadGraph()
    }

    /**********************************/
    /*** UIVIewController Methods ***/
    /**********************************/
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        /*** Setup top right button to be Play/Pause ***/
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        var topRightButton:UIBarButtonItem = UIBarButtonItem()
        
        // timer not set = Ready to Play
        if timerSet == false {
            topRightButton = buttonPlay
            graphRefreshTimer.invalidate()
        }
        else {
            topRightButton = buttonPause
            
            if !graphRefreshTimer.valid {
                graphRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("refreshGraph"), userInfo: nil, repeats: true)
            }
        }
        self.navigationItem.setRightBarButtonItem(topRightButton, animated: false)
        
        refreshLabel()
        glucGraph.reloadGraph()
        insuGraph.reloadGraph()
    }

    func playButtonPressed() {
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        
        if !timerSet {
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshValues:"), userInfo: nil, repeats: true)
            timerSet = true
        }
        
        graphRefreshTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("refreshGraph"), userInfo: nil, repeats: true)
        self.navigationItem.setRightBarButtonItem(buttonPause, animated: true)
    }
    func pauseButtonPressed() {
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        if timerSet {
            timer.invalidate()
            timerSet = false
        }
        
        graphRefreshTimer.invalidate()
        self.navigationItem.setRightBarButtonItem(buttonPlay, animated: true)
    }

    func refreshGraph() {
        refreshLabel()
        
        glucGraph.reloadGraph()
        insuGraph.reloadGraph()
    }
    
    /***********************/
    /*** Graph Methods ***/
    /***********************/

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph == glucGraph || graph == insuGraph{
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
        else if graph == insuGraph {
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
        if graph == glucGraph || graph == insuGraph{
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
        return (n_values + 1) * 12
    }

    func setupGraph() {
        var minGluc = BEMAverageLine()
        minGluc.yValue = 3
        minGluc.enableAverageLine = true
        minGluc.color = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
        minGluc.dashPattern = [5]
        
        var maxGluc = BEMAverageLine()
        maxGluc.yValue = 10
        maxGluc.enableAverageLine = true
        maxGluc.color = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        maxGluc.dashPattern = [5]
        
        glucGraph.minRefLine = minGluc
        glucGraph.maxRefLine = maxGluc
        
        glucGraph.enableYAxisLabel = true
        glucGraph.autoScaleYAxis = true
        glucGraph.enableReferenceAxisFrame = true
        glucGraph.enableXAxisLabel = true
        glucGraph.animationGraphEntranceTime = 0.5
        glucGraph.enablePopUpReport = true
        glucGraph.enableTouchReport = true
        
        glucGraph.formatStringForValues = "%.1f"
        
        insuGraph.enableYAxisLabel = true
        insuGraph.autoScaleYAxis = true
        insuGraph.enableReferenceAxisFrame = true
        insuGraph.enableXAxisLabel = true
        insuGraph.animationGraphEntranceTime = 0.5
        insuGraph.enablePopUpReport = true
        insuGraph.enableTouchReport = true
        
        insuGraph.formatStringForValues = "%.1f"
    }

    func refreshLabel() {
        let gluc = NSString(format: "%.2f", glucoseLevels.lastObject as! Float)
        let insu = NSString(format: "%.1f", insulinLevels.lastObject as! Float)
        
        glucLabel.text = "\(gluc)"
        insuLabel.text = "\(insu)"
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
        glucGraph.reloadGraph()
        insuGraph.reloadGraph()
    }
    
    /**********************/
    /*** Refresh Values ***/
    /**********************/
    @IBAction func refreshValues(sender: AnyObject) {
        if bt {
            println("JSON from BT")
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
        params["n"] = "\((n_values+1) * 3 * 12)"
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            if data == nil {
                println("ERROR")
                return
            }
            var json = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
                // WiFi not available
                
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the values
                    var items = parseJSON["items"] as! NSArray
//                    println("Items: \(items)")
                    println("JSON from WIFI")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

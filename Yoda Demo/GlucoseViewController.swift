//
//  GlucoseViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 28/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

var startDateTime:String = ""
let maxNumOfValues:Int = 86400
var inboxGI:NSMutableArray = []

class GlucoseViewController: UIViewController, BEMSimpleLineGraphDelegate {
    var timer = NSTimer()
    
    var bt = true
    
    var glucoseLevels:NSMutableArray = [0,0]
    var n_values:Int = 0
    var lastValueDate = ""
    
    @IBOutlet weak var glucLabel: UILabel!
    
    @IBOutlet weak var lastNSegmentedControl: UISegmentedControl!
    @IBAction func lastNValueChanged(sender: AnyObject) {
        n_values = lastNSegmentedControl.selectedSegmentIndex
        println(n_values)
        refreshValues(0)
    }
    
    @IBOutlet weak var glucGraph: BEMSimpleLineGraphView!
    
    func playButtonPressed() {
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshValues:"), userInfo: nil, repeats: true)
        
        self.navigationItem.setRightBarButtonItem(buttonPause, animated: true)
    }
    func pauseButtonPressed() {
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        timer.invalidate()
        
        self.navigationItem.setRightBarButtonItem(buttonPlay, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraph()
        
        var buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseButtonPressed")
        var buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playButtonPressed")
        
        self.navigationItem.setRightBarButtonItem(buttonPlay, animated: true)

//        refreshValues(0)
        // Do any additional setup after loading the view.
        
//        glucoseLevels.addObjectsFromArray([Int](count: maxNumOfValues, repeatedValue: 0))
        
        // Get the start of Simulation time
        if(startDateTime == "") {
            var components = NSString(string: "\(NSDate())").componentsSeparatedByString(" ")
            startDateTime = "\(components[0])&\(components[1])"
            lastValueDate = startDateTime
        }
//        timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshValues:"), userInfo: nil, repeats: true)
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
//        glucGraph.enableReferenceYAxisLines = true
        //        glucGraph.enableReferenceXAxisLines = true
        glucGraph.enableReferenceAxisFrame = true
        glucGraph.enableXAxisLabel = true
        glucGraph.animationGraphEntranceTime = 0.5
        glucGraph.enablePopUpReport = true
        glucGraph.enableTouchReport = true
        
        glucGraph.formatStringForValues = "%.2f"
    }

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph === glucGraph {
            return glucoseLevels.count
        }
        else {
            return 0
        }
    }

    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        
        if graph === glucGraph {
            return CGFloat(glucoseLevels.objectAtIndex(index) as! NSNumber)
        }
        else {
            return 0
        }
    }

    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        return "\(index * 5)"
    }
    
//    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
//        return 2
//    }
//    
//    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
//        return 15
//    }
    
    func refreshLabel(item:NSDictionary) {
        let gluc = item["gluc"] as? NSString
        if gluc != nil {
            glucLabel.text = NSString(format: "%.2f", (gluc!).floatValue) as String
        }
    }
    
    func drawGraph(items:NSArray) {
//        glucoseLevels.removeAllObjects()
        // time.removeAllObjects()
        
        var counter = 0
        
        for item in items {
            var date = item["date"] as! String
            if  date > startDateTime && date > lastValueDate {
                let gluc = (item["gluc"] as! NSString).floatValue
//                glucoseLevels.insertObject(gluc, atIndex: 0)
                glucoseLevels.addObject(gluc)
                lastValueDate = date
            }
            // time.addObject((counter++)*5)
        }
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
        params["n"] = "\((n_values+1) * 3 * 12)"
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Body: \(strData)")
            var err: NSError?
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
                    println("Items: \(items)")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.drawGraph(items)
                    }
                    
                    let item = items.firstObject as! NSDictionary
                    dispatch_async(dispatch_get_main_queue()) {
                        self.refreshLabel(item)
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

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
    
    @IBAction func refreshGraph(sender: AnyObject) {
        var api = "https://ic-yoda.appspot.com/_ah/api/icYodaApi/v1/glucInsuValues"
        var request = NSMutableURLRequest(URL: NSURL(string: api)!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        var params = [String:String]()
        params["n"] = "20"
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
                    
                    let item = items[0] as! NSDictionary
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
    
    func refreshLabel(item:NSDictionary) {
        let gluc = item["gluc"] as! String
        let insu = item["insu"] as! String
        
        self.glucoseLabel.text = "\(gluc)"
        self.insulinLabel.text = "\(insu)"
        
    }
    
    func drawGraph(items:NSArray) {
        glucoseLevels.removeAllObjects()
        insulinLevels.removeAllObjects()
        time.removeAllObjects()
        
        var counter = 0
        
        for item in items {
            let gluc = (item["gluc"] as! NSString).floatValue
            let insu = (item["insu"] as! NSString).floatValue
            
            glucoseLevels.insertObject(gluc, atIndex: 0)
            insulinLevels.insertObject(insu, atIndex: 0)
            time.addObject((counter++)*5)
        }

        myGraph.reloadGraph()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraph()
//        hydrateValues()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshGraph:"), userInfo: nil, repeats: true)
    }

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return glucoseLevels.count
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(glucoseLevels.objectAtIndex(index) as! NSNumber)
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        return "\(time[index])"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGraph() {
        myGraph.enableYAxisLabel = true
        myGraph.autoScaleYAxis = true
        myGraph.enableReferenceYAxisLines = true
        myGraph.enableReferenceXAxisLines = true
        myGraph.enableReferenceAxisFrame = true
        myGraph.enableXAxisLabel = true
        myGraph.animationGraphEntranceTime = 0.5
    
    }
}

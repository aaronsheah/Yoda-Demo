//
//  Vitals2ViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 21/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

class VitalsViewController: UIViewController, BEMSimpleLineGraphDelegate {
    var timer = NSTimer()
    
    var glucoseLevels:NSMutableArray = [0,0]
    var insulinLevels:NSMutableArray = [0,0]
    var time:NSMutableArray = [0,0]
    
    var n_values:Int = 0
    
    @IBOutlet weak var glucLabel: UILabel!
    @IBOutlet weak var insuLabel: UILabel!
    @IBOutlet weak var glucGraph: BEMSimpleLineGraphView!
    @IBOutlet weak var insuGraph: BEMSimpleLineGraphView!
    
    @IBOutlet weak var lastNSegmentedControl: UISegmentedControl!
    @IBAction func lastNValueChanged(sender: AnyObject) {
        n_values = lastNSegmentedControl.selectedSegmentIndex
        println(n_values)
        refreshValues(0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastNValueChanged(0)
        setupGraph()
        // timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: Selector("refreshGraph:"), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        if graph === glucGraph {
            return glucoseLevels.count
        }
        else if graph == insuGraph {
            return insulinLevels.count
        }
        else {
            return 0
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        
        if graph === glucGraph {
            return CGFloat(glucoseLevels.objectAtIndex(index) as! NSNumber)
        }
        else if graph == insuGraph {
            return CGFloat(insulinLevels.objectAtIndex(index) as! NSNumber)
        }
        else {
            return 0
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        return "\(time[index])"
    }
    
    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return (n_values + 1) * 12
    }
    
    func setupGraph() {
        glucGraph.enableYAxisLabel = true
        glucGraph.autoScaleYAxis = true
        //        glucGraph.enableReferenceYAxisLines = true
        //        glucGraph.enableReferenceXAxisLines = true
        glucGraph.enableReferenceAxisFrame = true
        glucGraph.enableXAxisLabel = true
        glucGraph.animationGraphEntranceTime = 0.5
        glucGraph.enablePopUpReport = true
        glucGraph.enableTouchReport = true
        
        insuGraph.enableYAxisLabel = true
        insuGraph.autoScaleYAxis = true
        //        insuGraph.enableReferenceYAxisLines = true
        //        insuGraph.enableReferenceXAxisLines = true
        insuGraph.enableReferenceAxisFrame = true
        insuGraph.enableXAxisLabel = true
        insuGraph.animationGraphEntranceTime = 0.5
        insuGraph.enablePopUpReport = true
        insuGraph.enableTouchReport = true
    }
    
    func refreshLabel(item:NSDictionary) {
        let gluc = item["gluc"] as! String
        let insu = item["insu"] as! String
        
        self.glucLabel.text = "\(gluc)"
        self.insuLabel.text = "\(insu)"
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
        
        glucGraph.reloadGraph()
        insuGraph.reloadGraph()
    }
    
    @IBAction func refreshValues(sender: AnyObject) {
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

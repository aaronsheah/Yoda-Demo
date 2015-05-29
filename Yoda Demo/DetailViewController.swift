//
//  DetailViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 07/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit
import CoreBluetooth

class DetailViewController: UIViewController, BEMSimpleLineGraphDelegate{

    /*****************************  Variables  **********************************/
    
    /************************************
                Send Via WiFi Options
    ************************************/

    var sendUrl:Bool! = true
    @IBOutlet weak var sendUrlSwitch: UISwitch!
    @IBAction func sendUrlSwitchAction(sender: AnyObject)  {
        sendUrl = sendUrlSwitch.on
    }
    

    /************************************
                    Chosen Meal
    ************************************/
    var meal:Meal = mealLibrary[0] as Meal
    var chosenIndex = 0
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!


    /************************************
                Feed/Reset Yoda
    ************************************/

    @IBOutlet weak var feedYodaButton: UIButton!
    @IBAction func feedYodaAction(sender: AnyObject) {
        sendData("\((meal.foods[chosenIndex] as! Food).id)")
    }
    @IBAction func resetYoda(sender: AnyObject) {
        var wifi = false
        var bt = false
        
        // Send via WiFi
        if sendUrl! {
            let url = NSURL(string: "http://ic-yoda.appspot.com/id?reset=1")
            let request = NSURLRequest(URL: url!)
            let connection = NSURLConnection(request: request, delegate:nil, startImmediately: true)
            wifi = true
        }
        // Send via Bluetooth
        if state == .CONNECTED {
            currentPeripheral.writeString("0,0,0,1\n")
            bt = true
        }
        
        var title = ""
        var message = "Reset via "
        if wifi || bt {
            title = "Yoda Reset"
            if wifi && !bt {
                message += "WiFi"
            }
            else if !wifi && bt {
                message += "Bluetooth"
            }
            else {
                message += "WiFi and Bluetooth"
            }
        }
        else {
            title = "Yoda NOT Reset"
            message = "WiFi and Bluetooth not available"
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    @IBOutlet weak var glucoseProfile: BEMSimpleLineGraphView!
    
    var customSC:UISegmentedControl!

    /*****************************  Functions  **********************************/

    /**************************************
            UIViewController Functions
    ***************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = meal.name
        nameLabel.text = meal.name
        foodImage.image = meal.thumbnail

        nameLabel.layer.shadowColor = (UIColor.blackColor()).CGColor
        nameLabel.layer.shadowOffset = CGSizeMake(0, 10)
        nameLabel.layer.shadowOpacity = 0.5
        
        // If more than one variation of meal ie: Low Fat Pasta, Medium Fat Pasta, High Fat Pasta
        if meal.foods.count != 1 {
            addSegmentedControl()
        }

        feedYodaButton.layer.cornerRadius = 5
        
        setupGraph()
    }
    
    override func viewWillAppear(animated: Bool) {
        glucoseProfile.reloadGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**************************************
            Add UISegmentedControl
    ***************************************/

    func addSegmentedControl () {
        self.title = "\(meal.name) (\((meal.foods[chosenIndex] as! Food).name))"

        var names:NSMutableArray = []

        for temp in meal.foods {
            var food = temp as! Food
            names.addObject(food.name)
        }

        // Initialize
        customSC = UISegmentedControl(items: names as [AnyObject])
        customSC.selectedSegmentIndex = chosenIndex

        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        var width:CGFloat = 60 * CGFloat(names.count)
        customSC.frame = CGRectMake(10, 75, width, 28)

        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.whiteColor()
        customSC.tintColor = UIColor.blueColor()

        // Add target action method
        customSC.addTarget(self, action: "reloadPage", forControlEvents: .ValueChanged)

        // Add this custom Segmented Control to our view
        self.view.addSubview(customSC)
    }

    func reloadPage() {
        chosenIndex = customSC.selectedSegmentIndex
        
        self.viewDidLoad()
        self.viewWillAppear(true)
    }

    /**************************************
        Segue to InfoTableViewController
    ***************************************/

    // MARK: - Pass data to InfoTableViewController

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "infoSegue" {
            (segue.destinationViewController as! InfoTableViewController).food = meal.foods[chosenIndex] as! Food
        }
    }

    /************************************
        BEMSImpleLineGraph Function
    ************************************/
    
    func setupGraph() {
        glucoseProfile.animationGraphEntranceTime = 1.5
        glucoseProfile.enableReferenceAxisFrame = true
        glucoseProfile.enableBezierCurve = false
    }

    // MARK: Delegate Functions
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        let food:Food = meal.foods[chosenIndex] as! Food
        return food.glucoseProfile.count
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        let food:Food = meal.foods[chosenIndex] as! Food
        return CGFloat(food.glucoseProfile.objectAtIndex(index) as! NSNumber)
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        let food:Food = meal.foods[chosenIndex] as! Food
        return "\(food.glucoseTime.objectAtIndex(index) as! NSNumber)"
    }
    
    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 11
    }

    /**************************************
            Bluetooth/WiFi Send Data
    ***************************************/
    func sendData(data:String) {
        // Send via WiFi
        if sendUrl! {
            let url = NSURL(string: "http://ic-yoda.appspot.com/id?id=\(data)&size=\(mealSize)")
            let request = NSURLRequest(URL: url!)
            let connection = NSURLConnection(request: request, delegate:nil, startImmediately: true)
        }
        // Send via Bluetooth
        var sentBT = false
        if state == .CONNECTED {
            currentPeripheral.writeString("D,\(data),0,\(mealSize),0\n")
            addTextToConsole("D,\(data),0,\(mealSize),0\n", dataType: .TX)
            sentBT = true
        }
        
        var title = ""
        var message = ""
        
        if !(sendUrl!) && !(sentBT) {
            title = "Yoda NOT Fed!"
            message = ":("
        }
        else {
            title = "Yoda Fed!"
            message = "Yoda just ate \(meal.name) via "
            if (sendUrl!) && !(sentBT) {
                message += "WiFi"
            }
            else if !(sendUrl!) && (sentBT) {
                message += "Bluetooth"
            }
            else {
                message += "WiFi and Bluetooth"
            }
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func didReceiveData(string: String!) {
        addTextToConsole(string, dataType: .RX)
    }
    
    /****************************************************************/
    /**                                                            **/
    /****************************************************************/
    
    func addTextToConsole(string:NSString, dataType:ConsoleDataType) {
        var direction:NSString
        
        switch dataType {
        case .RX:
            direction = "RX"
            break
        case .TX:
            direction = "TX"
            break
        case .LOGGING:
            direction = "LOGGING"
        }
        
        var formatter:NSDateFormatter
        formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        
        var output:NSString = "[\(formatter.stringFromDate(NSDate()))] \(direction) \(string)"
        
        println(output)
    }

    
}

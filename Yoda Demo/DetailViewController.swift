//
//  DetailViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 07/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit
import CoreBluetooth

var splitViewController: SplitViewController! = nil

class DetailViewController: UIViewController, BEMSimpleLineGraphDelegate{
    
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    var readyToSend:Bool! = false
    
    var sendUrl:Bool! = true
    @IBOutlet weak var sendUrlSwitch: UISwitch!
    @IBAction func sendUrlSwitchAction(sender: AnyObject) {
        if sendUrlSwitch.on {
            sendUrl = true
        }
        else {
            sendUrl = false
        }
    }
    
    var meal:Meal = mealLibrary[0] as Meal
    var chosenIndex = 0
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var feedYodaButton: UIButton!
    @IBAction func feedYodaAction(sender: AnyObject) {
        sendData("\((meal.foods[chosenIndex] as! Food).id)")
    }
    @IBAction func resetYoda(sender: AnyObject) {
        if sendUrl! {
            let url = NSURL(string: "http://ic-yoda.appspot.com/id?reset=1")
            let request = NSURLRequest(URL: url!)
            let connection = NSURLConnection(request: request, delegate:nil, startImmediately: true)
        }
    }

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var glucoseProfile: BEMSimpleLineGraphView!
    
    var customSC:UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = meal.name
        nameLabel.text = meal.name
        foodImage.image = meal.thumbnail
        
        if meal.foods.count != 1 {
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
        
        // Do any additional setup after loading the view.
        setupGraph()
        
        feedYodaButton.layer.cornerRadius = 5
    }

    func reloadPage() {
        chosenIndex = customSC.selectedSegmentIndex
        
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        glucoseProfile.reloadGraph()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupGraph() {
        glucoseProfile.animationGraphEntranceTime = 1.5
        glucoseProfile.enableReferenceAxisFrame = true
        
//        glucoseProfile.layer.borderColor = UIColor.blackColor().CGColor
//        glucoseProfile.layer.cornerRadius = 5
//        glucoseProfile.layer.borderWidth = 1
        
        glucoseProfile.enableBezierCurve = false
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "infoSegue" {
            (segue.destinationViewController as! InfoTableViewController).food = meal.foods[chosenIndex] as! Food
        }
    }

    // MARK: Graph
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
    
    func sendData(data:String) {
        if sendUrl! {
            let url = NSURL(string: "http://ic-yoda.appspot.com/id?id=\(data)&size=\(mealSize)")
            let request = NSURLRequest(URL: url!)
            let connection = NSURLConnection(request: request, delegate:nil, startImmediately: true)
        }
        
        if(!readyToSend) {
            println("Not Ready to Send : \(data)")
            
            var alertView:UIAlertController!
            if sendUrl! {
                alertView = UIAlertController(title: "Yoda Fed!", message: "Yoda just ate \(meal.name) via WiFi", preferredStyle: .Alert)
                
            }
            else {
                alertView = UIAlertController(title: "Yoda NOT Fed!", message: ":(", preferredStyle: .Alert)
            }
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
            return
        }
        
        var didSend:Bool = true
        
        let chunk = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        didSend = peripheralManager.updateValue(chunk, forCharacteristic: transferCharacteristic, onSubscribedCentrals: nil)
        
        if(didSend) {
            println("Sent : \(data)")
            
            var alertView:UIAlertController!
            if sendUrl! {
                alertView = UIAlertController(title: "Yoda Fed!", message: "Yoda just ate \(meal.name) via WiFi & Bluetooth", preferredStyle: .Alert)
            }
            else {
                alertView = UIAlertController(title: "Yoda Fed!", message: "Yoda just ate \(meal.name) via Bluetooth", preferredStyle: .Alert)
            }
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        else {
            let alertView = UIAlertController(title: "Yoda NOT Fed!", message: ":(", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
}

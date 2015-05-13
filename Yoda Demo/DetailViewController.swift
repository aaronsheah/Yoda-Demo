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
    
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    var readyToSend:Bool! = false
    
    var sendUrl:Bool! = false
    @IBOutlet weak var sendUrlSwitch: UISwitch!
    @IBAction func sendUrlSwitchAction(sender: AnyObject) {
        if sendUrlSwitch.on {
            sendUrl = true
        }
        else {
            sendUrl = false
        }
    }
    
    var food:Food = foodLibrary[0]
    
    @IBOutlet weak var variantsButton: UISegmentedControl!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var feedYodaButton: UIButton!
    @IBAction func feedYodaAction(sender: AnyObject) {
        sendData("\(food.id)")
    }

    @IBOutlet weak var descLabel: UILabel!

    
    @IBOutlet weak var glucoseProfile: BEMSimpleLineGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = food.name
        nameLabel.text = food.name
        foodImage.image = food.thumbnail
        descLabel.text = food.description
        
        // Do any additional setup after loading the view.
        
        setupGraph()
        
        feedYodaButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGraph() {
        glucoseProfile.animationGraphEntranceTime = 1.5
        
        glucoseProfile.layer.borderColor = UIColor.blackColor().CGColor
        glucoseProfile.layer.cornerRadius = 5
        glucoseProfile.layer.borderWidth = 1
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return food.glucoseProfile.count
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(food.glucoseProfile.objectAtIndex(index) as! NSNumber)
    }
    
    func sendData(data:String) {
        if sendUrl! {
            let url = NSURL(string: "http://ic-yoda.appspot.com/id?id=\(data)")
            let request = NSURLRequest(URL: url!)
            let connection = NSURLConnection(request: request, delegate:nil, startImmediately: true)
        }
        
        if(!readyToSend) {
            println("Not Ready to Send : \(data)")
            
            var alertView:UIAlertController!
            if sendUrl! {
                alertView = UIAlertController(title: "Yoda Fed!", message: "Yoda just ate \(food.name) via WiFi", preferredStyle: .Alert)
                
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
                alertView = UIAlertController(title: "Yoda Fed!", message: "Yoda just ate \(food.name) via WiFi & Bluetooth", preferredStyle: .Alert)
            }
            else {
                alertView = UIAlertController(title: "Yoda Fed!", message: "Yoda just ate \(food.name) via Bluetooth", preferredStyle: .Alert)
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

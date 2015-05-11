//
//  PeripheralViewController.swift
//  Bluetooth
//
//  Created by Aaron Sheah on 09/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController, CBPeripheralManagerDelegate{
    
    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    
    var serviceUUID = CBUUID(string: "ABCD")
    var characteristicUUID = CBUUID(string: "0123")
    
    var dataToSend:NSData!
    var sendDataIndex:NSInteger!
    
    var readyToSend:Bool = false
    var queue:NSMutableArray = []
    
    @IBAction func button1(sender: AnyObject) {
        sendData("1")
    }
    @IBAction func button2(sender: AnyObject) {
        sendData("2")
    }
    @IBAction func button3(sender: AnyObject) {
        sendData("3")
    }
    
    @IBOutlet weak var isAdvertisingLabel: UILabel!
    
    @IBAction func refresh(sender: AnyObject) {
        isAdvertisingLabel.text = "\(self.peripheralManager.isAdvertising)"
    }
    

    @IBOutlet weak var toggle: UISwitch!
    @IBAction func startAdvertisingSwitch(sender: AnyObject) {
        if toggle.on {
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[serviceUUID]])
        }
        else {
            peripheralManager.stopAdvertising()
        }
    }
    
    /*****************************************************************************/
    // View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        
    }

    override func viewWillDisappear(animated: Bool) {
        peripheralManager.stopAdvertising()
        
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*****************************************************************************/
    
    /*****************************************************************************/
    // Peripheral Manager Delegate required Methods

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if(peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        }
        
        println("peripheralManager powered on")
        
        // Build characteristic
        transferCharacteristic = CBMutableCharacteristic(type: characteristicUUID, properties: CBCharacteristicProperties.Notify, value: nil, permissions: CBAttributePermissions.Readable)
        
        // Build Service
        var transferService:CBMutableService = CBMutableService(type: serviceUUID, primary: true)
        
        // Add Characteristic to Service
        transferService.characteristics = [transferCharacteristic]
        
        // Add Service to Peripheral Manager
        peripheralManager.addService(transferService)
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        println("Central subscribed to characteristic")
        
        // Ready to Send
        readyToSend = true
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
        println("Central UNsubscribed from characteristic")
        
        readyToSend = false
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        return
    }
    
    func sendData(data:String) {
        if(!readyToSend) {
            println("Not Ready to Send : \(data)")
            return
        }
        
        var didSend:Bool = true
        
        let chunk = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        didSend = peripheralManager.updateValue(chunk, forCharacteristic: transferCharacteristic, onSubscribedCentrals: nil)
        
        if(didSend) {
            println("Sent : \(data)")
        }
    }
    
    /*****************************************************************************/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

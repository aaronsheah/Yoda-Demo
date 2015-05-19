import UIKit
import AVFoundation
import CoreBluetooth

var detailViewController: DetailViewController? = nil

class foodCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    var eatingSounds = [
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("eat", ofType: "mp3")!)
    ]
    
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func feedButton(sender: AnyObject) {
        let n = UInt32(eatingSounds.count)
        let randomNumber:Int = Int(arc4random_uniform(n))
        audioPlayer = AVAudioPlayer(contentsOfURL: eatingSounds[randomNumber], error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}

class FoodLibraryTableViewController: UITableViewController, UITableViewDelegate, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var toggle: UISwitch!
    @IBAction func startAdvertisingSwitch(sender: AnyObject) {
        if toggle.on {
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[serviceUUID]])
        }
        else {
            peripheralManager.stopAdvertising()
        }
    }
    
    @IBOutlet weak var connectionLabel: UILabel!

    var peripheralManager:CBPeripheralManager!
    var transferCharacteristic:CBMutableCharacteristic!
    
    var serviceUUID = CBUUID(string: "ABCD")
    var characteristicUUID = CBUUID(string: "0123")
    
    var dataToSend:NSData!
    
    var readyToSend:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionLabel.textColor = UIColor.redColor()
        
        // tableView.allowsSelection = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Peripheral Manger Delegate
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if(peripheral.state != CBPeripheralManagerState.PoweredOn) {
            connectionLabel.textColor = UIColor.redColor()
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
        
        connectionLabel.textColor = UIColor.greenColor()
        
        // Ready to Send
        readyToSend = true
        
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
        println("Central UNsubscribed from characteristic")
        
        connectionLabel.textColor = UIColor.redColor()
        
        readyToSend = false
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        return
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return mealLibrary.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! foodCell

        let meal = mealLibrary[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.thumbnail.image = meal.thumbnail

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let object = objects[indexPath.row] as NSDate
        //self.detailViewController!.detailItem = object
        // pizza.pizzaType = pizza.typeList[indexPath.row] //set to the selected pizza
        // if (detailViewController != nil){
        //    self.detailViewController!.detailItem = pizza //send the model to the detailItem
        //}
        if detailViewController != nil {
            detailViewController!.meal = mealLibrary[indexPath.row] as Meal!
            detailViewController!.peripheralManager = peripheralManager
            detailViewController!.transferCharacteristic = transferCharacteristic
            detailViewController!.readyToSend = readyToSend
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            //    let object = objects[indexPath.row] as NSDate
            //((segue.destinationViewController as UINavigationController).topViewController as DetailViewController).detailItem = object
            let meal = mealLibrary[indexPath!.row] as Meal //set to the selected pizza
            ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).meal = meal
            ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).peripheralManager = peripheralManager
            ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).transferCharacteristic = transferCharacteristic
            ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).readyToSend = readyToSend
        }
    }


}

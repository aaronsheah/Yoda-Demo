import UIKit
import AVFoundation
import CoreBluetooth

var detailViewController: DetailViewController? = nil

enum ConnectionState{
    case IDLE
    case SCANNING
    case CONNECTED
}

enum ConsoleDataType{
    case LOGGING
    case RX
    case TX
}

class foodCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
}

var currentPeripheral:UARTPeripheral!
var state:ConnectionState = .IDLE

class FoodLibraryTableViewController: UITableViewController, UITableViewDelegate, CBCentralManagerDelegate, UARTPeripheralDelegate {

    var centralManager:CBCentralManager!
    
    
    @IBOutlet weak var connectButton: UIButton!
    @IBAction func connectButtonPressed(sender: AnyObject) {
        
        switch state {
        case .IDLE:
            state = .SCANNING
            println("Started scan ...")
            connectButton.setTitle("Scanning ...", forState: UIControlState.Normal)
            centralManager.scanForPeripheralsWithServices([UARTPeripheral.uartServiceUUID()], options:[CBCentralManagerScanOptionAllowDuplicatesKey: false as NSNumber])
            
        case .SCANNING:
            state = .IDLE
            println("Stopped scan")
            connectButton.setTitle("Connect", forState: UIControlState.Normal)
            
        case .CONNECTED:
            println("Disconnected peripheral")
            centralManager.cancelPeripheralConnection(currentPeripheral.peripheral)
            
            
        default:
            println("Something else")
        }
    }
    
    /****************************************************************/
    /**                          CB                                **/
    /****************************************************************/
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if(central.state != CBCentralManagerState.PoweredOn){
            println("centralManager powered off")
            return
        }
        
        println("centralManager powered on")
        connectButton.enabled = true
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Did discover peripheral \(peripheral.name)")
        
        centralManager.stopScan()
        
        currentPeripheral = UARTPeripheral(peripheral: peripheral, delegate: self)
        centralManager.connectPeripheral(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Did connect peripheral \(peripheral.name)")
        state = .CONNECTED
        connectButton.setTitle("Disconnect", forState: UIControlState.Normal)
        
        if currentPeripheral.peripheral.isEqual(peripheral) {
            currentPeripheral.didConnect()
        }
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Did disconnect peripheral \(peripheral.name)")
        
        state = .IDLE
        connectButton.setTitle("Connect", forState: UIControlState.Normal)
        
        if currentPeripheral.peripheral.isEqual(peripheral) {
            currentPeripheral.didDisconnect()
        }
        
    }
    
    /****************************************************************/
    /**                                                            **/
    /****************************************************************/
    
    @IBAction func send(sender: AnyObject) {
        sendData("1", mealSize: "75", reset:"0")
    }
    
    func sendData(mealID:NSString, mealSize:NSString, reset:NSString) {
        currentPeripheral.writeString("\(mealID),0,\(mealSize),\(reset)\n")
        addTextToConsole("\(mealID),0,\(mealSize),\(reset)\n", dataType: .TX)
    }
    
    func didReceiveData(string: String!) {
        addTextToConsole(string, dataType: .RX)
        
        var input = NSString(string: string).componentsSeparatedByString(",")
        
        if input.count != 2 {
            return
        }
        
        var glucose = input[0] as! NSString
        var insulin = input[1] as! NSString
        
        var components = NSString(string: "\(NSDate())").componentsSeparatedByString(" ")
        var datetime = "\(components[0])&\(components[1])"
        
        var output:NSDictionary = [
            "date":datetime,
            "gluc":glucose,
            "insu":insulin,
        ]
        
        inboxGI.addObject(output)
        
        println("\(output)")
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
    

    /************************************
            UIViewController Functions
    ************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /******************************
            Table View Functions
    ******************************/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    

    /**********************************************
        Passing Data to the Detail View Controller
    ***********************************************/

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if detailViewController != nil {
            detailViewController!.meal = mealLibrary[indexPath.row] as Meal!
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let meal = mealLibrary[indexPath!.row] as Meal //set to the selected pizza
            ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).meal = meal
        }
    }
}

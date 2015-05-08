import UIKit
import AVFoundation

var detailViewController: DetailViewController? = nil

class foodCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    
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

class FoodLibraryTableViewController: UITableViewController, UITableViewDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.allowsSelection = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return foodLibrary.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! foodCell

        let food = foodLibrary[indexPath.row]
        
        cell.nameLabel.text = food.name
        cell.thumbnail.image = food.thumbnail

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
            detailViewController!.food = foodLibrary[indexPath.row]
        }
        println(indexPath.row)
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
            let food = foodLibrary[indexPath!.row] //set to the selected pizza
            ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).food = food
        }
    }


}

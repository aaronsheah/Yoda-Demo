//
//  InfoTableViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 15/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

var mealSize:Int = 2

class InfoTableViewController: UITableViewController {

    var food:Food!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var choLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var mealSizeSlider: UISlider!
    @IBAction func mealSizeChange(sender: AnyObject) {
        var temp = Int(mealSizeSlider.value)
        if temp < 1 {
            mealSizeLabel.text = "Low"
            mealSize = 1
        }
        else if temp < 2 {
            mealSizeLabel.text = "Medium"
            mealSize = 2
        }
        else if temp < 3 {
            mealSizeLabel.text = "High"
            mealSize = 3
        }
    }
    @IBOutlet weak var mealSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealSizeChange(0)
        
        tableView.allowsSelection = false
        
        if food != nil {
            descLabel.text = food.description
            
            choLabel.text = NSString(format: "%.01f", food.cho) as String + "%"
            proteinLabel.text = NSString(format: "%.01f", food.protein) as String + "%"
            fatLabel.text = NSString(format: "%.01f", food.fat) as String + "%"
        }
        else {
            descLabel.text = "1"
            choLabel.text = "2%"
            proteinLabel.text = "3%"
            fatLabel.text = "4%"
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

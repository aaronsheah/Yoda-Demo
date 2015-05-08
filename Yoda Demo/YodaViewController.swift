//
//  YodaViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 30/04/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit
import AVFoundation

var num_meals:Int = 0
var mealBasket:NSMutableArray = []

class YodaViewController: UIViewController, UITableViewDataSource{
    var timer = NSTimer()
    
    @IBOutlet weak var speechImage: UIImageView!
    @IBOutlet weak var mealBasketTable: UITableView!

    @IBAction func reloadTable(sender: AnyObject) {
        mealBasketTable.reloadData()
    }
    
    @IBAction func feedYoda(sender: AnyObject) {
        println(mealBasket)
    }
    
    @IBAction func clearBasket(sender: AnyObject) {
        mealBasket = []
        reloadTable(0)
    }
    

    func tableView(mealBasketTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealBasket.count
    }
    
    func tableView(mealBasketTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // dequeue a cell for the given indexPath
        let cell = UITableViewCell()
        
        // set the cell's text with the new string formatting
        cell.textLabel!.text = mealBasket[indexPath.row] as? String
        
        return cell
    }

    var quotes = [
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("900YEARS", ofType: "WAV")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("GETSOBIG", ofType: "WAV")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("SEEKYODA", ofType: "WAV")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("YODA3", ofType: "WAV")!)
    ]
    
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func yodaSpeak(sender: AnyObject) {
        let n = UInt32(quotes.count)
        let randomNumber:Int = Int(arc4random_uniform(n))
        audioPlayer = AVAudioPlayer(contentsOfURL: quotes[randomNumber], error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        speechImage.alpha = 1
        
        UIView.animateWithDuration(3, animations: { () -> Void in
            self.speechImage.alpha = 0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("reload"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        reloadTable(0)
    }
}
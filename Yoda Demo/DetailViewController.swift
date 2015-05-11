//
//  DetailViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 07/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, BEMSimpleLineGraphDelegate{

    var food:Food = foodLibrary[0]
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var feedYodaButton: UIButton!
    @IBAction func feedYodaAction(sender: AnyObject) {

        println("feed")
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
    
}

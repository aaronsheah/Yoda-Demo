//
//  SettingsViewController.swift
//  Yoda Demo
//
//  Created by Aaron Sheah on 29/05/2015.
//  Copyright (c) 2015 Aaron Sheah. All rights reserved.
//

import UIKit

var bt:Bool = false
var wifi:Bool = true

class SettingsViewController: UIViewController {

    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBAction func wifiSwitchToggle(sender: AnyObject) {
        wifi = wifiSwitch.on
    }
    @IBOutlet weak var btSwitch: UISwitch!
    @IBAction func btSwitchToggle(sender: AnyObject) {
        bt = btSwitch.on
        println("\(bt)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        wifiSwitch.setOn(wifi, animated: false)
        btSwitch.setOn(bt, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  DemoHardwareApp
//
//  Created by Nehal Kanetkar on 2016-06-01.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit

let pebbleConnectedNotificationKey = "pebbleConnected"
let pebbleDisconnectedNotificationKey = "pebbleDisconnected"

class ViewController: UIViewController {
    @IBOutlet weak var OffButton: UIButton!
    @IBOutlet weak var OnButton: UIButton!
    
    let pebbleController = PebbleCommunication.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.setPebbleStatusConnected), name: pebbleConnectedNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.setPebbleStatusDisconnected), name: pebbleDisconnectedNotificationKey, object: nil)
        self.setPebbleStatusDisconnected()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func OffButtonPressed(sender: AnyObject) {
        OffButton.alpha = 1.0
        print("Off Button Pressed")
        pebbleController.sendDictionary([NSNumber(int: 0): NSString(string: "Wong")], completionHandler: { (error) -> Void in
            print("Sent message with artist", "Edrick", "and title", "My love")
        })
    }
    
    @IBAction func OnButtonPressed(sender: AnyObject) {
        OnButton.alpha = 1.0
        print("On Button Pressed")
        pebbleController.sendDictionary([NSNumber(int: 0): NSString(string: "Edrick")], completionHandler: { (error) -> Void in
            print("Sent message with artist", "Edrick", "and title", "My love")
        })
    }
    
    @IBAction func OnButtonTouchDown(sender: AnyObject) {
        OnButton.alpha = 0.8
    }
    @IBAction func OffButtonTouchDown(sender: AnyObject) {
        OffButton.alpha = 0.8
    }
    
    func setPebbleStatusConnected() {
        print("Connected")
    }
    
    func setPebbleStatusDisconnected() {
        print("Disconnected")
    }
}


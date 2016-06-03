//
//  PebbleCommuncation.swift
//  DemoHardwareApp
//
//  Created by Nehal Kanetkar on 2016-06-01.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import Foundation
import PebbleKit

protocol PebbleCommunicationDelegate {
    func pebbleController(pebbleController: PebbleCommunication, receivedMessage: Dictionary<NSObject, AnyObject>)
}

class PebbleCommunication: NSObject, PBPebbleCentralDelegate {
    
    class var instance : PebbleCommunication {
        struct Static {
            static let instance : PebbleCommunication = PebbleCommunication()
        }
        return Static.instance
    }
    
    var watch: PBWatch?
    var delegate: PebbleCommunicationDelegate?
    var dictionary = Dictionary<Int, String>()
    
    //Set the app UUID
    var UUID: String? {
        didSet {
            let myAppUUID = NSUUID(UUIDString: self.UUID!)
            var myAppUUIDbytes: UInt8 = 0
            myAppUUID?.getUUIDBytes(&myAppUUIDbytes)
            PBPebbleCentral.defaultCentral().appUUID = myAppUUID
            if (self.watch != nil) {
                self.watch?.appMessagesAddReceiveUpdateHandler({ (watch, msgDictionary) -> Bool in
                    print("Message received")
                    self.delegate?.pebbleController(self, receivedMessage: msgDictionary)
                    return true
                })
            }
        }
    }
    
    override init() {
        super.init()
        PBPebbleCentral.defaultCentral().delegate = self
        self.watch = PBPebbleCentral.defaultCentral().lastConnectedWatch()
        if (self.watch != nil) {
            print("Pebble found: \(self.watch!.name)")
        }
        PBPebbleCentral.defaultCentral().run()
    }
    
    func isSupported() {
        if ((watch?.versionInfo?.appMessagesSupported()) != nil) {
            print(watch?.versionInfo?.appMessagesSupported())
        }
    }
    
    func pebbleCentral(central: PBPebbleCentral, watchDidConnect watch: PBWatch, isNew: Bool) {
        print("Pebble did connect: \(watch.name)")
        NSNotificationCenter.defaultCenter().postNotificationName("pebbleConnected", object: nil)
    }
    
    func pebbleCentral(central: PBPebbleCentral, watchDidDisconnect watch: PBWatch) {
        print("Pebble did disconnect: \(watch.name)")
        if (self.watch == watch) {
            self.watch = nil
        }
        NSNotificationCenter.defaultCenter().postNotificationName("pebbleDisconnected", object: nil)
    }
    
    func launchApp(completionHandler: (error: NSError?) -> Void) {
        self.watch?.appMessagesLaunch({ (watch, error) -> Void in
            completionHandler(error: error)
        })
    }
    
    func killApp(completionHandler: (error: NSError?) -> Void) {
        self.watch?.appMessagesKill({ (watch, error) -> Void in
            completionHandler(error: error)
        })
    }
    
    func sendDictionary(dictionary: [NSNumber: NSNumber], completionHandler: (error: NSError?) -> Void) {
        if dictionary.isEmpty {
            return
        }
        self.watch?.appMessagesPushUpdate(dictionary, onSent: { (watch, msgDictionary, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                print(dictionary, "sent to Pebble successfully")
            }
        })
    }
}
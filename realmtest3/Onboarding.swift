//
//  Onboarding.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 4/5/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift

class Onboarding: UIViewController {

    @IBAction func skipButton(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
        //self.performSegueWithIdentifier("showNew", sender: self)
    }
}

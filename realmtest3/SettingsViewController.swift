//
//  SettingsViewController.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 4/5/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listView: UITableView!
     let items: [String] = ["Something here", "Addresses", "Log out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        (navigationController?.navigationBarHidden = false)!
        navigationItem.title = "Settings"
        listView.dataSource = self
        listView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cells:UITableViewCell = self.listView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cells.textLabel?.text = self.items[indexPath.row]
        
        return cells
        
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       print(indexPath.row)
        if indexPath.row == 1{
            let addressViewController = self.storyboard?.instantiateViewControllerWithIdentifier("showAddressContainer") as! ShowAddress
            self.navigationController?.pushViewController(addressViewController, animated: true)

        }
        if indexPath.row == 2{
            let loginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            self.view.addSubview(loginButton)
            
            func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
                print("logged out")
                self.dismissViewControllerAnimated(true, completion: nil)
            }

        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*if (FBSDKAccessToken.currentAccessToken() == nil)
{
print("Not logged in")
}
else
{
print("Logged in")
//let storyboard = UIStoryboard(name: "HomeView", bundle: nil)
//let vc = storyboard.instantiateViewControllerWithIdentifier("TestDataViewController") as! UIViewController
//self.presentViewController(vc, animated: true, completion: nil)
//self.performSegueWithIdentifier("showNew", sender: self)
}
let loginButton = FBSDKLoginButton()
//loginButton.readPermissions = ["public_profile","email", "user_friends"]
loginButton.center = self.view.center

//loginButton.delegate = self
self.view.addSubview(loginButton)


}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
}



func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
print("logged out")
}
 */
}


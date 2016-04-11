//
//  ViewController.swift
//  testswift
//
//  Created by Ashlee Beggs on 3/19/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import RealmSwift
import Realm
import Firebase


class ViewController: UIViewController {
    let realm = try! Realm()
    let refAUTH = Firebase(url: "https://sosapp2.firebaseio.com")
    let refUSERS = Firebase(url: "https://sosapp2.firebaseio.com/users/uid")
    let ref = Firebase(url: "https://sosapp2.firebaseio.com")
    let refPATH = Firebase(url: "https://sosapp2.firebaseio.com/items")

    @IBAction func loginButton(sender: AnyObject) {
        launchApp()
    }//close button
    
    override func viewDidLoad() {
        
        // app already launched
        //print("has launched")
        let newItems = ItemsList2()
        
        
        newItems.category = "munchies"
        newItems.type = "snack"
        newItems.name = "Ice cream"
        newItems.price = "1.99"
        newItems.id = "1"
        
        /*try! realm.write {
        realm.add(newItems)
        }*/

        //, FBSDKLoginButtonDelegate
        
        
        let item = ["0": ["name": "coke", "price": "1.99", "type": "drink", "category": "hangover"], "1": ["name": "water", "price": "0.99", "type": "drink", "category": "hangover"], "2": ["name": "chips", "price": "3.99", "type": "snack", "category": "hangover"], "3": ["name": "gatorade", "price": "0.99", "type": "drink", "category": "hangover"], "4": ["name": "gatorade", "price": "1.99", "type": "drink", "category": "sick"], "5": ["name": "ice cream", "price": "4.99", "type": "snack", "category": "sick"], "6": ["name": "ice cream", "price": "4.99", "type": "snack", "category": "breakup"], "7": ["name": "lemonade", "price": "3.99", "type": "drink", "category": "breakup"]]
        refPATH.setValue(item)
        
        super.viewDidLoad()
        
    }
    
    func launchApp(){
        
        //TOKEN DOES NOT EXIST
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in")
            let ref = Firebase(url: "https://sosapp2.firebaseio.com")
            
            let facebookLogin = FBSDKLoginManager()
            
            facebookLogin.logInWithReadPermissions(["email", "user_friends"], handler: {
                (facebookResult, facebookError) -> Void in
                
                if facebookError != nil {
                    print("Facebook login failed. Error \(facebookError)")
                }
                    
                else if facebookResult.isCancelled {
                    print("Facebook login was cancelled.")
                }
                    
                else {
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    ref.authWithOAuthProvider("facebook", token: accessToken,
                        withCompletionBlock: { error, authData in
                            
                            if error != nil {
                                print("Login failed. \(error)")
                            }
                                
                                //THERE IS NO ERROR USER LOGGED IN
                            else {
                                
                                self.refUSERS.observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
                                    let userfound = snapshot.value.objectForKey("uid") as? String
                                    print(userfound)
                                    let emailName = authData.providerData["email"]!
                                    
                                    //CHECK IF AUTH ID EXISTS
                                    if userfound == authData.uid{
                                        print("found", authData.uid)
                                        self.performSegueWithIdentifier("showNew", sender: self)
                                        //DOWNLOAD ITEMS DATA, AND CATEGORY DATA
                                        
                                        let itemList = ItemsList2()
                                        let toDeleteList = self.realm.objects(ItemsList2)
                                        
                                        try! self.realm.write {
                                            self.realm.delete(toDeleteList)
                                        }//close realm
                                        
                                        let profile = Items()
                                        let toDelete = self.realm.objects(Items)
                                        
                                        try! self.realm.write {
                                            self.realm.delete(toDelete)
                                        }//close realm
                                        
                                        profile.fbemail = emailName as! String
                                        profile.fbname = authData.uid
                                        
                                        try! self.realm.write {
                                            print("added here")
                                            self.realm.add(profile)
                                        } //close realm
                                        
                                        self.refPATH.observeEventType(.ChildAdded, withBlock: { snap in
                                            let objc = snap.value.objectForKey("category") as? String
                                            let objt = snap.value.objectForKey("type") as? String
                                            let objn = snap.value.objectForKey("name") as? String
                                            let objp = snap.value.objectForKey("price") as? String
                                            let ItemsRealm = ItemsList2()
                                            
                                            
                                            ItemsRealm.category = objc!
                                            ItemsRealm.type = objt!
                                            ItemsRealm.name = objn!
                                            ItemsRealm.price = objp!
                                            try! self.realm.write {
                                                self.realm.add(ItemsRealm)
                                                print(ItemsRealm)
                                            }
                                            
                                            if snap.value is NSNull {
                                                // The value is null
                                            }
                                            
                                        })//close observeeventtype

                                    }
                                        //AUTH ID DOESNT EXIST
                                    else{
                                        
                                        let usersRef = self.refAUTH.childByAppendingPath("users/uid/" + authData.uid)
                                        let usertest = ["email": emailName, "uid": authData.uid]
                                        usersRef.setValue(usertest)
                                        let profile = Items()
                                        let toDelete = self.realm.objects(Items)
                                        
                                        try! self.realm.write {
                                            self.realm.delete(toDelete)
                                        }//close realm
                                        
                                        profile.fbemail = emailName as! String
                                        profile.fbname = authData.uid
                                        
                                        try! self.realm.write {
                                            print("added here")
                                            self.realm.add(profile)
                                        } //close realm
                                        
                                        //DOWNLOAD ITEMS DATA
                                        
                                        let itemList = ItemsList2()
                                        let toDeleteList = self.realm.objects(ItemsList2)
                                        
                                        try! self.realm.write {
                                            self.realm.delete(toDeleteList)
                                        }//close realm
                                        
                                        self.refPATH.observeEventType(.ChildAdded, withBlock: { snap in
                                            let objc = snap.value.objectForKey("category") as? String
                                            let objt = snap.value.objectForKey("type") as? String
                                            let objn = snap.value.objectForKey("name") as? String
                                            let objp = snap.value.objectForKey("price") as? String
                                            let ItemsRealm = ItemsList2()
                                            
                                            
                                            ItemsRealm.category = objc!
                                            ItemsRealm.type = objt!
                                            ItemsRealm.name = objn!
                                            ItemsRealm.price = objp!
                                            try! self.realm.write {
                                                self.realm.add(ItemsRealm)
                                                print(ItemsRealm)
                                            }
                                            
                                            if snap.value is NSNull {
                                                // The value is null
                                            }
                                            
                                        })//close observeeventtype
                                        
                                       self.performSegueWithIdentifier("showNew", sender: self)
                                        
                                    }// close else
                                    
                                    
                                    
                                    
                                }) // close observesingleeventoftype
                            } // close else
                    }) //close authwithoauthprovider
                } // close else (successful login)
                
            })//login with read permissions
        }// close if
            
            //TOKEN EXISTS ALREADY
        else
        {
            ref.observeAuthEventWithBlock({ authData in
                if authData != nil {
                    //ERASING ITEMSLIST
                    let itemList = ItemsList2()
                    let toDeleteList = self.realm.objects(ItemsList2)
                    
                    try! self.realm.write {
                        self.realm.delete(toDeleteList)
                    }//close realm
                    
                    //GETTING FIREBASE ITEMS SEND TO REALM ITEMSLIST
                    self.refPATH.observeEventType(.ChildAdded, withBlock: { snap in
                        let objc = snap.value.objectForKey("category") as? String
                        let objt = snap.value.objectForKey("type") as? String
                        let objn = snap.value.objectForKey("name") as? String
                        let objp = snap.value.objectForKey("price") as? String
                        let ItemsRealm = ItemsList2()
                        
                        
                        ItemsRealm.category = objc!
                        ItemsRealm.type = objt!
                        ItemsRealm.name = objn!
                        ItemsRealm.price = objp!
                        try! self.realm.write {
                            self.realm.add(ItemsRealm)
                           // print(ItemsRealm)
                        }
                        
                        if snap.value is NSNull {
                            // The value is null
                        }
                        
                    })//close observeeventtype
                    
                    //ERASING HANGOVER
                    let hangover = MyItemsRealm()
                    let toDeleteh = self.realm.objects(MyItemsRealm)
                    
                    try! self.realm.write {
                        self.realm.delete(toDeleteh)
                    }//close realm
                    
                    //GETTING FIREBASE ITEMS SEND TO REALM HANGOVER
                    let usersh = self.refAUTH.childByAppendingPath("users/uid/" + authData.uid + "/hangover/item")
                    usersh.observeEventType(.ChildAdded, withBlock: { snap in
                        let objt = snap.value.objectForKey("type") as? String
                        let objp = snap.value.objectForKey("price") as? String
                        let objn = snap.value.objectForKey("name") as? String
                        let objc = snap.value.objectForKey("category") as? String
                        
                        let myItemsRealm = MyItemsRealm()
                        
                        
                        myItemsRealm.category = objc!
                        myItemsRealm.type = objt!
                        myItemsRealm.name = objn!
                        myItemsRealm.price = objp!
                        try! self.realm.write {
                            self.realm.add(myItemsRealm)
                            print(myItemsRealm)
                        }
                        
                        if snap.value is NSNull {
                            // The value is null
                            print("nothing here in hangover")
                        }
                        
                    })//close observeeventtype
                    
                    //ERASING SICK
                    let sick = MySickItemsRealm()
                    let toDeletes = self.realm.objects(MySickItemsRealm)
                    
                    try! self.realm.write {
                        self.realm.delete(toDeletes)
                    }//close realm

                    //GETTING FIREBASE ITEMS SEND TO REALM SICK
                    let userss = self.refAUTH.childByAppendingPath("users/uid/" + authData.uid + "/sick/item")
                    userss.observeEventType(.ChildAdded, withBlock: { snap in
                        let objt = snap.value.objectForKey("type") as? String
                        let objp = snap.value.objectForKey("price") as? String
                        let objn = snap.value.objectForKey("name") as? String
                        let objc = snap.value.objectForKey("category") as? String
                        
                        let mySickItemsRealm = MySickItemsRealm()
                        
                        
                        mySickItemsRealm.category = objc!
                        mySickItemsRealm.type = objt!
                        mySickItemsRealm.name = objn!
                        mySickItemsRealm.price = objp!
                        try! self.realm.write {
                            self.realm.add(mySickItemsRealm)
                            print(mySickItemsRealm)
                        }
                        
                        if snap.value is NSNull {
                            // The value is null
                            print("nothing here in sick")
                        }
                        
                    })//close observeeventtype
                    
                    //ERASING BREAKUP
                    let bu = MyBUItemsRealm()
                    let toDeleteb = self.realm.objects(MyBUItemsRealm)
                    
                    try! self.realm.write {
                        self.realm.delete(toDeleteb)
                    }//close realm
                    
                    //GETTING FIREBASE ITEMS SEND TO REALM SICK
                    let usersb = self.refAUTH.childByAppendingPath("users/uid/" + authData.uid + "/breakup/item")
                    usersb.observeEventType(.ChildAdded, withBlock: { snap in
                        let objt = snap.value.objectForKey("type") as? String
                        let objp = snap.value.objectForKey("price") as? String
                        let objn = snap.value.objectForKey("name") as? String
                        let objc = snap.value.objectForKey("category") as? String
                        
                        let myBUItemsRealm = MyBUItemsRealm()
                        
                        
                        myBUItemsRealm.category = objc!
                        myBUItemsRealm.type = objt!
                        myBUItemsRealm.name = objn!
                        myBUItemsRealm.price = objp!
                        try! self.realm.write {
                            self.realm.add(myBUItemsRealm)
                            print(myBUItemsRealm)
                        }
                        
                        if snap.value is NSNull {
                            // The value is null
                            print("nothing here in breakup")
                        }
                        
                    })//close observeeventtype


                    
                    //print(authData.uid)
                    self.performSegueWithIdentifier("showNew", sender: nil)
                }//close if
                else {
                    // No user is signed in
                    print("nothing")
                }//close else
            }) //close observeautheventwithblock
            
            
            
        } //CLOSE ELse
    }
    override func viewWillAppear(animated: Bool) {
         //self.performSegueWithIdentifier("showNew", sender: self)    }
    }
   }
/*
if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce"))
{
print("has launched before")

}
else{
print("has not launched before")
}

print("Logged in")
let ref = Firebase(url: "https://sosapp2.firebaseio.com")

ref.observeAuthEventWithBlock({ authData in
if authData != nil {
// user authenticated
print(authData.uid)
self.performSegueWithIdentifier("showNew", sender: nil)
}//close if
else {
// No user is signed in
print("nothing")
}//close else
}) //close observeautheventwithblock
*/


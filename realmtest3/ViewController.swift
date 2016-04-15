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
       /* //print("has launched")
        let newItems = ItemsList2()
        
        
        newItems.category = "munchies"
        newItems.type = "snack"
        newItems.name = "Ice cream"
        newItems.price = "1.99"
        newItems.id = "1"
        
        try! realm.write {
        realm.add(newItems)
        }*/

        //, FBSDKLoginButtonDelegate
        
        //ITEMS TO ADD TO FIREBASE
        let item = ["0": ["name": "coke", "price": "1.99", "type": "drink", "category": "hangover"], "1": ["name": "water", "price": "0.99", "type": "drink", "category": "hangover"], "2": ["name": "chips", "price": "3.99", "type": "snack", "category": "hangover"], "3": ["name": "gatorade", "price": "0.99", "type": "drink", "category": "hangover"], "4": ["name": "gatorade", "price": "1.99", "type": "drink", "category": "sick"], "5": ["name": "ice cream", "price": "4.99", "type": "snack", "category": "sick"], "6": ["name": "ice cream", "price": "4.99", "type": "snack", "category": "breakup"], "7": ["name": "lemonade", "price": "3.99", "type": "drink", "category": "breakup"]]
        //ADDING TO FIREBASE
        refPATH.setValue(item)
        
        super.viewDidLoad()
        
    }
    
    func launchApp(){
        
        //CHECKING IF TOKEN DOES NOT EXIST
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in")
            let ref = Firebase(url: "https://sosapp2.firebaseio.com")
            
            let facebookLogin = FBSDKLoginManager()
            
            //ASKING FOR PERMISSIONS
            facebookLogin.logInWithReadPermissions(["email", "user_friends"], handler: {
                (facebookResult, facebookError) -> Void in
                
                //IF THERE IS A FB ERROR
                if facebookError != nil {
                    print("Facebook login failed. Error \(facebookError)")
                }
                //IF FB CANCELS
                else if facebookResult.isCancelled {
                    print("Facebook login was cancelled.")
                }
                //IF THERE IS NOT A FB ERROR
                else {
                    //CREATE ACCESS TOKEN
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    //ACCESS FIREBASE WITH TOKEN
                    ref.authWithOAuthProvider("facebook", token: accessToken,
                        withCompletionBlock: { error, authData in
                            
                            //IF THERES AN ERROR
                            if error != nil {
                                print("Login failed. \(error)")
                            }
                                
                            //IF THERE IS NO ERROR
                            else {
                                
                                self.refUSERS.observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
                                    //ACCESSING UIDS
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
                                        //CLEAR OUT REALM
                                        do {
                                            try self.realm.write() {
                                                self.realm.delete(toDeleteList)
                                            }
                                        } catch {
                                            print("Something went wrong!")
                                        }//close realm
                                        
                                        let profile = Items()
                                        let toDelete = self.realm.objects(Items)
                                        //CLEAR OUT REALM
                                        do {
                                            try self.realm.write() {
                                                 self.realm.delete(toDelete)
                                            }
                                        } catch {
                                            print("Something went wrong!")
                                        }//close realm
                                        
                                        profile.fbemail = emailName as! String
                                        profile.fbname = authData.uid
                                        //ADDING EMAIL, UID TO REALM
                                        do {
                                            try self.realm.write() {
                                                 self.realm.add(profile)
                                            }
                                        } catch {
                                            print("Something went wrong!")
                                        }//close realm

                                        //ASSIGNING FIREBASE OBJECTS TO VARIABLES
                                        self.refPATH.observeEventType(.ChildAdded, withBlock: { snap in
                                            let objc = snap.value.objectForKey("category") as? String
                                            let objt = snap.value.objectForKey("type") as? String
                                            let objn = snap.value.objectForKey("name") as? String
                                            let objp = snap.value.objectForKey("price") as? String
                                            let ItemsRealm = ItemsList2()
                                            
                                            //ASSOCIATING THE VARIABLES TO REALM OBJECTS
                                            ItemsRealm.category = objc!
                                            ItemsRealm.type = objt!
                                            ItemsRealm.name = objn!
                                            ItemsRealm.price = objp!
                                            //ADDING ITEMS FROM FIREBASE TO REALM
                                            do {
                                                try self.realm.write() {
                                                    self.realm.add(ItemsRealm)
                                                }
                                            } catch {
                                                print("Something went wrong!")
                                            }//close realm
                                            
                                            //IF THERE IS NO DATA IN FIREBASE
                                            if snap.value is NSNull {
                                                print("data is null")
                                            }
                                            
                                            }, withCancelBlock: { error in
                                                print(error.description)
                                        })//close observeeventtype

                                    }
                                    //IF AUTH ID DOESNT EXIST
                                    else{
                                        
                                        let usersRef = self.refAUTH.childByAppendingPath("users/uid/" + authData.uid)
                                        let usertest = ["email": emailName, "uid": authData.uid]
                                        //ADDING EMAIL, UID TO FIREBASE
                                        usersRef.setValue(usertest)
                                        
                                        let profile = Items()
                                        let toDelete = self.realm.objects(Items)
                                        //CLEARING OUT REALM
                                        do {
                                            try self.realm.write() {
                                                self.realm.delete(toDelete)
                                            }
                                        } catch {
                                            print("Something went wrong!")
                                        }//close realm
                                        
                                        profile.fbemail = emailName as! String
                                        profile.fbname = authData.uid
                                        //ADDING EMAIL, UID TO REALM
                                        do {
                                            try self.realm.write() {
                                                self.realm.add(profile)
                                            }
                                        } catch {
                                            print("Something went wrong!")
                                        }//close realm
                                        
                                        
                                        //DOWNLOAD ITEMS DATA
                                        let itemList = ItemsList2()
                                        let toDeleteList = self.realm.objects(ItemsList2)
                                        //CLEARING OUT REALM
                                        do {
                                            try self.realm.write() {
                                                self.realm.delete(toDeleteList)
                                            }
                                        } catch {
                                            print("Something went wrong!")
                                        }//close realm
                                        
                                        //ASSOCIATING FIREBASE OBJECTS WITH VARIABLES
                                        self.refPATH.observeEventType(.ChildAdded, withBlock: { snap in
                                            let objc = snap.value.objectForKey("category") as? String
                                            let objt = snap.value.objectForKey("type") as? String
                                            let objn = snap.value.objectForKey("name") as? String
                                            let objp = snap.value.objectForKey("price") as? String
                                            let ItemsRealm = ItemsList2()
                                            
                                            //ASSOCIATING TO REALM OBJECTS
                                            ItemsRealm.category = objc!
                                            ItemsRealm.type = objt!
                                            ItemsRealm.name = objn!
                                            ItemsRealm.price = objp!
                                            //ADDING VARIABLES TO REALM
                                            do {
                                                try self.realm.write() {
                                                    self.realm.add(ItemsRealm)
                                                }
                                            } catch {
                                                print("Something went wrong!")
                                            }//close realm
                                           
                                            //IF THERE IS NO DATA
                                            if snap.value is NSNull {
                                                print("no items")
                                            }
                                            
                                        })//close observeeventtype
                                        //GO TO NEXT PAGE
                                       self.performSegueWithIdentifier("showNew", sender: self)
                                        
                                    }// close else
                                    
                                    }, withCancelBlock: { error in
                                        print(error.description)
                                }) // close observesingleeventoftype
                            } // close else
                    }) //close authwithoauthprovider
                } // close else (successful login)
                
            })//login with read permissions
        }// close if
            
        //IF A TOKEN EXISTS ALREADY
        else
        {
            //let scoresRef = Firebase(url:"https://sosapp2.firebaseio.com/items")
            //scoresRef.keepSynced(true)
            //CHECKING FOR FIREBASE DATA
            ref.observeAuthEventWithBlock({ authData in
                // IF THERE IS DATA
                if authData != nil {
                    //ERASING ITEMSLIST
                    let itemList = ItemsList2()
                    let toDeleteList = self.realm.objects(ItemsList2)
                    //CLEARING REALM
                    do {
                        try self.realm.write() {
                           self.realm.delete(toDeleteList)
                        }
                    } catch {
                        print("Something went wrong!")
                    }//close realm
                    
                    //GETTING FIREBASE ITEMS SEND TO REALM ITEMSLIST
                    self.refPATH.observeEventType(.ChildAdded, withBlock: { snap in
                        let objc = snap.value.objectForKey("category") as? String
                        let objt = snap.value.objectForKey("type") as? String
                        let objn = snap.value.objectForKey("name") as? String
                        let objp = snap.value.objectForKey("price") as? String
                        let ItemsRealm = ItemsList2()
                        
                        //ASSOCIATING TO REALM OBJECTS
                        ItemsRealm.category = objc!
                        ItemsRealm.type = objt!
                        ItemsRealm.name = objn!
                        ItemsRealm.price = objp!
                        //ADDING TO REALM
                        do {
                            try self.realm.write() {
                                self.realm.add(ItemsRealm)
                            }
                        } catch {
                            print("Something went wrong!")
                        }//close realm
                        
                        //IF THERE IS NO DATA
                        if snap.value is NSNull {
                            print("there is no items")
                        }
                        
                        }, withCancelBlock: { error in
                            print(error.description)
                    })//close observeeventtype
                    
                    //ERASING HANGOVER
                    let hangover = MyItemsRealm()
                    let toDeleteh = self.realm.objects(MyItemsRealm)
                    //CLEARING REALM
                    do {
                        try self.realm.write() {
                            self.realm.delete(toDeleteh)
                        }
                    } catch {
                        print("Something went wrong!")
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
                        //ADDING TO REALM
                        do {
                            try self.realm.write() {
                               self.realm.add(myItemsRealm)
                            }
                        } catch {
                            print("Something went wrong!")
                        }//close realm
                        //IF NO DATA
                        if snap.value is NSNull {
                            // The value is null
                            print("nothing here in hangover")
                        }
                        
                        }, withCancelBlock: { error in
                            print(error.description)
                    })//close observeeventtype
                    
                    //ERASING SICK
                    let sick = MySickItemsRealm()
                    let toDeletes = self.realm.objects(MySickItemsRealm)
                    //CLEARING REALM
                    do {
                        try self.realm.write() {
                            self.realm.delete(toDeletes)
                        }
                    } catch {
                        print("Something went wrong!")
                    }//close realm
                   

                    //GETTING FIREBASE ITEMS SEND TO REALM SICK
                    let userss = self.refAUTH.childByAppendingPath("users/uid/" + authData.uid + "/sick/item")
                    userss.observeEventType(.ChildAdded, withBlock: { snap in
                        let objt = snap.value.objectForKey("type") as? String
                        let objp = snap.value.objectForKey("price") as? String
                        let objn = snap.value.objectForKey("name") as? String
                        let objc = snap.value.objectForKey("category") as? String
                        
                        let mySickItemsRealm = MySickItemsRealm()
                        
                        //ASSIGNING TO MYSICKITEMS REALM
                        mySickItemsRealm.category = objc!
                        mySickItemsRealm.type = objt!
                        mySickItemsRealm.name = objn!
                        mySickItemsRealm.price = objp!
                        //ADDING TO REALM
                        do {
                            try self.realm.write() {
                                self.realm.add(mySickItemsRealm)
                            }
                        } catch {
                            print("Something went wrong!")
                        }//close realm
                        
                        //NO SICK ITEMS
                        if snap.value is NSNull {
                            // The value is null
                            print("nothing here in sick")
                        }
                        
                        }, withCancelBlock: { error in
                            print(error.description)
                    })//close observeeventtype
                    
                    //ERASING BREAKUP
                    let bu = MyBUItemsRealm()
                    let toDeleteb = self.realm.objects(MyBUItemsRealm)
                    //CLEARING REALM
                    do {
                        try self.realm.write() {
                            self.realm.delete(toDeleteb)
                        }
                    } catch {
                        print("Something went wrong!")
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
                        //ADDING TO BREAKUP REALM
                        do {
                            try self.realm.write() {
                                self.realm.add(myBUItemsRealm)
                            }
                        } catch {
                            print("Something went wrong!")
                        }//close realm

                        //NO DATA
                        if snap.value is NSNull {
                            // The value is null
                            print("nothing here in breakup")
                        }
                        
                        }, withCancelBlock: { error in
                            print(error.description)
                    })//close observeeventtype

                    //TRANSITION TO NEXT PAGE
                    self.performSegueWithIdentifier("showNew", sender: nil)
                }//close if
                else {
                // No user is signed in
                    print("no user is signed in")
                }//close else
            }) //close observeautheventwithblock
            
        } //CLOSE ELse
    }
    override func viewWillAppear(animated: Bool) {
        
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


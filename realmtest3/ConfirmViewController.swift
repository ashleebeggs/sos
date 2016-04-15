//
//  DetailViewController.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/22/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class ConfirmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, myProtocol {
   
    var datasource : Results<MyItemsRealm>!
    let addressRealm = Address()
    let realm = try! Realm()
    var myItemsarray: [AnyObject] = []
    var myItemsarrayPrice: [Double] = []
    
   
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var TableFieldConfirm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (navigationController?.navigationBarHidden = false)!
        navigationItem.title = "Confirm"
        getCount()
        getData()
        getAddress()
        aggregateLabelCount()
        
        
        print(datasource)
        
        TableFieldConfirm.dataSource = self
        TableFieldConfirm.delegate = self
        
        //PRE LOADING PHONE NUMBER IF IT EXISTS
        let phone = realm.objects(Items)
        if phone[0].phone != ""{
            phoneNumber.text = phone[0].phone
            //print(phone[0].phone)
        } else {
            phoneNumber.placeholder = "Phone number"
        }
        
    }
    
    @IBAction func orderButton(sender: AnyObject) {
        let ref = Firebase(url: "https://sosapp2.firebaseio.com")
        //GETTING FIREBASE DATA
        ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                
                //CHECKING FOR A PHONE NUMBER INPUT
                if self.phoneNumber.text != "" {
                    print("writing")
                    let phone = Items()
                    let toDelete = self.realm.objects(Items)
                    
                    //GETTING THE FB ID
                    let profileID = toDelete[0].fbname
                    print(toDelete[0])
                    
                    //CREATING PATH TO USERS HANGOVER IN FIREBASE
                    let usersRef = ref.childByAppendingPath("users/uid/" + profileID + "/hangover")
                    
                    //TAKING THE ITEMS SELECTED AND ADDING THEM TO FIREBASE
                    let items = ["item": self.myItemsarray]
                    usersRef.setValue(items, withCompletionBlock: {
                        (error:NSError?, ref:Firebase!) in
                        if (error != nil) {
                            print("Data could not be saved.")
                        } else {
                            print("Data saved successfully!")
                        }
                    })
                   

                    //CHECKING FOR A SAVED PHONE NUMBER
                    if phone.phone == ""{
                      //CLEARING OUT THE REALM DATA
                        do {
                            try self.realm.write() {
                                self.realm.delete(toDelete)
                            }
                        } catch {
                            print("Something went wrong!")
                        }//close realm
                        
                        
                        //RESAVING PHONE NUMBER, EMAIL, UID
                        phone.phone = self.phoneNumber.text!
                        phone.fbemail = authData.providerData["email"] as! String
                        phone.fbname = authData.uid as String
                        do {
                            try self.realm.write() {
                                self.realm.add(phone)
                            }
                        } catch {
                            print("Something went wrong!")
                        }//close realm
                    }//close phone.phone
                    else{
                        //THERE ALREADY EXISTS A PHONE NUMBER IN REALM, NO ACTION NEEDED
                        print(phone)
                    }//close else
                    
                }// close if
                else{
                    //ALERT IF NO PHONE NUMBER WAS ENTERED INTO THE INPUT AND WE DONT HAVE IT SAVED
                    let alertController = UIAlertController(title: "Deets", message: "We need your number in case we need to contact you.", preferredStyle: .Alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            }//close if
            else {
                // NO DATA FOUND
                print("NO DATA FOUND")
            }//close else
        }) //close observeautheventwithblock
        
        //CHECKING IF THERE IS AN ADDRESS SELECTED
        if addressLabel.text == "Add an address"{
            //ALERT IF NO ADDRESS SELECTED, AND WE DONT HAVE ONE SAVED
            let alertController = UIAlertController(title: "Location", message: "Enter an address so we can deliver your noms.", preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }//close if

    }
    
    
    @IBAction func address(sender: AnyObject) {
        //SHOWING THE ADDRESSES SAVED IN REALM
        let showAddressController = storyboard?.instantiateViewControllerWithIdentifier("showViewController") as! ShowAddress
        // ASSIGNING THE DELEGATE TO PASS DATA BACK
        showAddressController.mydelegate = self
        
        self.presentViewController(showAddressController, animated: true, completion: nil)
        
    }
    func getData(){
        //FILTERING FOR HANGOVER ITEMS IN REALM
        let test = NSPredicate(format: "category = 'hangover'")
        datasource = realm.objects(MyItemsRealm).filter(test)
       // print(datasource)
        
    }
    
    func aggregateLabelCount(){
        //ADDING ALL THE PRICES TOGETHER TO GET THE TOTAL
        let myItems = realm.objects(MyItemsRealm)
            if myItems.count != 0{
            print(myItemsarrayPrice, "this is whats in myitemsarrayprice")
            let numbers = [Double](myItemsarrayPrice)
            let total = numbers.reduce(0, combine: +)
                totalAmount.text = String("Total: ") + String(total)
        }
        else{
            totalAmount.text = "0"
        }
    }

    
    func getAddress(){
        //PRE POPULATE THE ADDRESS IF WE HAVE ONE SAVED IN REALM
     let addressRealm = realm.objects(Address)
        if addressRealm.count > 0{
        addressLabel.text = addressRealm[0].street
        } else{
            addressLabel.text = "Add an address"
            print("no addresses")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //RETURNING COUNT OF ALL THE ITEMS WE FILTERS IN GETDATA
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.TableFieldConfirm?.dequeueReusableCellWithIdentifier("confirmCellID") as! ConfirmItemRow
        let itemList = datasource[indexPath.row]
        cell.updateView(itemList.name + "-" + itemList.price)
        
        return cell
    }
    
    func getCount(){
        //GETTING COUNT OF OBJECTS IN PRICE ARRAY, AND RESAVING ALL THE ITEMS SELECTED TO A FORMAT FIREBASE CAN USE
        let myItems = realm.objects(MyItemsRealm)
        let num = myItems.count
        myItemsarrayPrice.removeAll()
        myItemsarray.removeAll()
        
        for var i = 0; i < num; i++ {
            let intAmount = Double(myItems[i].price)
            if intAmount != nil{
               //GOING THROUGH ALL THE ITEMS AND ADDING PRICES TO AN ARRAY
                var myItemsArrayPrice =  myItemsarrayPrice.append(intAmount!)
                //GOING THROUGH ALL THE ITEMS AND REFORMATTING FOR FIREBASE
                myItemsarray.append(["name": myItems[i].name, "price": myItems[i].price, "type": myItems[i].type, "category": myItems[i].category])
               

            } else {print("im nil") }
        }
        print(myItemsarrayPrice)
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
    
    
    @IBAction func addressFunc(sender: AnyObject) {
        let showAddressController = storyboard?.instantiateViewControllerWithIdentifier("showAddressContainer") as! ShowAddress
        showAddressController.mydelegate = self
        self.presentViewController(showAddressController, animated: true, completion: nil)
        
    }
   
    func sendBackChoice(aStreet: String){
        //DISPLAY THE SELECTED ADDRESS CHOSEN FROM SHOW ADDRESS VIEW CONTROLLER
        print(aStreet, "here i am")
        addressLabel.text = aStreet
        
    }
}



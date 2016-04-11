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
    //@IBOutlet weak var TableField: UITableView!
    var datasource : Results<MyItemsRealm>!
    let addressRealm = Address()
    let realm = try! Realm()
    var myItemsarray: [AnyObject] = []
    var myItemsarrayPrice: [Double] = []
    let ref = Firebase(url: "https://sosapp2.firebaseio.com")

    
    
   
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
        
        
        TableFieldConfirm.dataSource = self
        TableFieldConfirm.delegate = self
        let phone = realm.objects(Items)
        if phone[0].phone != ""{
            phoneNumber.text = phone[0].phone
            print(phone[0].phone)
        } else {
            phoneNumber.placeholder = "Phone number"
        }
        
                    
    }
    
    @IBAction func orderButton(sender: AnyObject) {
        ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                print("working")
                if self.phoneNumber.text != "" {
                    print("writing")
                    let phone = Items()
                    let toDelete = self.realm.objects(Items)
                    if phone.phone == ""{
                        
                        try! self.realm.write {
                            self.realm.delete(toDelete)
                        }//close realm
                        
                        phone.phone = self.phoneNumber.text!
                        phone.fbemail = authData.providerData["email"] as! String
                        phone.fbname = authData.uid as! String
                        try! self.realm.write {
                       self.realm.add(phone)
                        }//close realm
                    }//close phone.phone
                    else{
                        print(phone)
                    }//close else
                    
                }// close if
                else{
                    //ALERT
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
                // No user is signed in
                print("nothing")
            }//close else
        }) //close observeautheventwithblock
        
    }
    @IBAction func address(sender: AnyObject) {
        let showAddressController = storyboard?.instantiateViewControllerWithIdentifier("showViewController") as! ShowAddress
        showAddressController.mydelegate = self
        self.presentViewController(showAddressController, animated: true, completion: nil)
    }
    func getData(){
        let test = NSPredicate(format: "category = 'hangover'")
        datasource = realm.objects(MyItemsRealm).filter(test)
       // print(datasource)
        
    }
    
    func aggregateLabelCount(){
        let myItems = realm.objects(MyItemsRealm)
            if myItems.count != 0{
            let numbers = [Double](myItemsarrayPrice)
            let total = numbers.reduce(0, combine: +)
                totalAmount.text = String("Total: ") + String(total)
        }
        else{
            totalAmount.text = "0"
        }
        
        
        //print (myItemsarray)
    }

    
    func getAddress(){
     let addressRealm = realm.objects(Address)
        if addressRealm.count > 0{
        addressLabel.text = addressRealm[0].street
        } else{
            print("no addresses")
        }
        //print(addressRealm)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - UITableView
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        let myItems = realm.objects(MyItemsRealm)
        let num = myItems.count
        myItemsarrayPrice.removeAll()
        //myItemsarray.removeAll()
        
        for var i = 0; i < num; i++ {
            let intAmount = Double(myItems[i].price)
            if intAmount != nil{
                //var myItemsArray =  myItemsarray.append(myItems[i].name)
                var myItemsArrayPrice =  myItemsarrayPrice.append(intAmount!)
            } else {print("im nil") }
        }
        print(myItemsarrayPrice)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
   
    func sendBackChoice(aStreet: String){
        print(aStreet, "here i am")
        addressLabel.text = aStreet
        
    }
}



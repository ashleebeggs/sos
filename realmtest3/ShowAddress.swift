//
//  DetailViewController.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/22/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift

protocol myProtocol{
    func sendBackChoice(aStreet: String)
    
}

class ShowAddress: UIViewController, UITableViewDelegate, UITableViewDataSource, SwiftAlertViewDelegate, myUpdateProtocol {
    //@IBOutlet weak var TableField: UITableView!
    var datasource : Results<Address>!
    var mydelegate: myProtocol?
    let addressRealm = Address()
    let realm = try! Realm()
    var holder: [AnyObject] = []
    
    @IBOutlet weak var AddressField: UITableView!
    @IBOutlet var modalView: UIView!
    
    @IBAction func AddressFunction(sender: AnyObject) {
        //SHOWING THE ADDRESSES SAVED IN REALM
        let showAddressController = storyboard?.instantiateViewControllerWithIdentifier("addAddressController") as! AddAddress
        // ASSIGNING THE DELEGATE TO PASS DATA BACK
        showAddressController.myUpdatedelegate = self
        self.presentViewController(showAddressController, animated: true, completion: nil)
    }
    @IBAction func sendBack(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelAddress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //(navigationController?.navigationBarHidden = false)!
        //navigationItem.title = "Addresses"
        getData()
        //getAddress()
        
        AddressField.dataSource = self
        AddressField.delegate = self
        
        //self.AddressField.reloadData()
    }
    
    func getData(){
        datasource = realm.objects(Address)
        print(datasource)
        
    }
    
    func getAddress(){
        let addressRealm = realm.objects(Address)
        print(addressRealm)
        
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
        let expl = "No addresses yet"
        let cell = self.AddressField?.dequeueReusableCellWithIdentifier("AddressCellID") as! ShowAddressItemRow
        let itemList = datasource[indexPath.row]
        if datasource.count > 0 {
            cell.updateView(itemList.street)
        } else{
            cell.updateView(expl)
        }
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = self.AddressField?.dequeueReusableCellWithIdentifier("AddressCellID") as! ShowAddressItemRow
        
        let deletedValue = datasource[indexPath.row].street
        //IF DELETING ROW
        if editingStyle == .Delete {
            //FILTER
            let filterBroadMyItemsRealm = NSPredicate(format: "street = '" + deletedValue + "'")
            let deletedNotifications = realm.objects(Address).filter(filterBroadMyItemsRealm)
            //REMOVING DELETED ITEMS FROM REALM
            do {
                try realm.write() {
                    realm.delete(deletedNotifications)
                }
            } catch {
                
                //ALERT IF ERROR
                let alertController = UIAlertController(title: "Error", message: "Couldn't delete this address", preferredStyle: .Alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                }
                
                // Add the actions
                alertController.addAction(okAction)
            

            }//close realm
            
            self.AddressField.reloadData()
            
        } else {}
    }//close tableview

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let itemList = datasource[indexPath.row].street
        //holder.append(itemList)
        
        mydelegate?.sendBackChoice(datasource[indexPath.row].street)
        
    }



    func sendBackNewAddress(newAddress: String){
        //DISPLAY THE SELECTED ADDRESS CHOSEN FROM SHOW ADDRESS VIEW CONTROLLER
        print(newAddress, "here i am")
        self.AddressField.reloadData()
        //addressLabel.text = newAddress
        
    }
    
   
}

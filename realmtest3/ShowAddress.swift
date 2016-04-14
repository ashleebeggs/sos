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

class ShowAddress: UIViewController, UITableViewDelegate, UITableViewDataSource, SwiftAlertViewDelegate {
    //@IBOutlet weak var TableField: UITableView!
    var datasource : Results<Address>!
    var mydelegate: myProtocol?
    let addressRealm = Address()
    let realm = try! Realm()
    var holder: [AnyObject] = []
    
    @IBOutlet weak var AddressField: UITableView!
    @IBOutlet var modalView: UIView!
    
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
        
        self.AddressField.reloadData()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemList = datasource[indexPath.row].street
        //holder.append(itemList)
        
        mydelegate?.sendBackChoice(datasource[indexPath.row].street)
        
    }
    
   
}

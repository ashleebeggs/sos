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

class SickDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableField2: UITableView!
    @IBOutlet weak var totalCount2: UILabel!
    @IBOutlet weak var aggregateLabel2: UILabel!
    
    var datasource : Results<ItemsList2>!
    var datasource2 : Results<MySickItemsRealm>!
    let realm = try! Realm()
    var ref = Firebase(url: "https://sosapp2.firebaseio.com/")
    
    var myItemsarray: [Dictionary<String, AnyObject>] = []
    var myItemsCount: [AnyObject] = []
    var myItemsarrayPrice: [Double] = []
    
    @IBAction func drinkButton(sender: AnyObject) {
        let drinks = NSPredicate(format: "type = 'drink' AND category = 'sick'")
        datasource = realm.objects(ItemsList2).filter(drinks)
        self.TableField2.reloadData()
        //print(datasource)
    }
    @IBAction func snackButton(sender: AnyObject) {
        let drinks = NSPredicate(format: "type = 'snack' AND category = 'sick'")
        datasource = realm.objects(ItemsList2).filter(drinks)
        self.TableField2.reloadData()
        //print(datasource)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sick"
        (navigationController?.navigationBarHidden = false)!
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveToFirebase")
        getData()
        getCount()
        aggregateLabelCount()
        totalLabelCount()
        TableField2.dataSource = self
        TableField2.delegate = self
        
        // Do any additional setup after loading the view.
    }
    func goNow(){
        saveToFirebase()
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConfirmView") as! ConfirmViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getData(){
        let test = NSPredicate(format: "type = 'drink' AND category = 'sick'")
    datasource = realm.objects(ItemsList2).filter(test)
        //print(datasource)
        
    }
    
    
    func totalLabelCount(){
        let myItems = realm.objects(MySickItemsRealm)
        // print(myItems, "this is whats in label count")
        if myItems.count != 0{
            print(myItemsarrayPrice, "this is whats in myitemsarrayprice")
            let numbers = [Double](myItemsarrayPrice)
            let total = numbers.reduce(0, combine: +)
            totalCount2.text = String("Total: ") + String(total)
            print(totalCount2.text, "this is the total", total)
        }
            
        else{
            totalCount2.text = "0"
        }
        
    }
    
    func getCount(){
        let myItems = realm.objects(MySickItemsRealm)
        let num = myItems.count
        
        myItemsarrayPrice.removeAll()
        myItemsarray.removeAll()
        for var i = 0; i < num; i++ {
            let intAmount = Double(myItems[i].price)
            if intAmount != nil{
                
                myItemsarray.append(["name": myItems[i].name, "price": myItems[i].price, "type": myItems[i].type, "category": myItems[i].category])
                myItemsarrayPrice.append(intAmount!)
                
            } else {print("im nil") }
            
            // print(myItemsarray)
            
        }
        print(myItemsarrayPrice)
        
    }
    
    
    func aggregateLabelCount(){
        let myItems = realm.objects(MySickItemsRealm)
        let num = myItems.count
        if myItems.count > 0{
            aggregateLabel2.text = "Items " + String(num)
        }
        else if myItems.count == 0{
            aggregateLabel2.text = "Items 0"
        }
        //print (myItemsarray)
    }
    
    func saveToFirebase(){
        print(myItemsarray, "these are the items that will be saved")
        let profileInfo = realm.objects(Items)
        let profileID = profileInfo[0].fbname
        print(profileID)
        
        let usersRef = ref.childByAppendingPath("users/uid/" + profileID + "/sick")
        
        let items = ["item": myItemsarray]
        print(items)
        usersRef.setValue(items)
        //print("setting something long here so i can ssee it", items)
        
        //ALERT
        let alertController = UIAlertController(title: "Order", message: "Do you want to order this now?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes, order", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("sickSegue", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Not now", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.performSegueWithIdentifier("sickNoSegue", sender: self)
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }


    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = self.TableField2?.dequeueReusableCellWithIdentifier("ItemRowCellID2") as! SickItemRow
        let itemList = datasource[indexPath.row]
        cell.updateView(itemList.name)
        
        let filterMyItemsRealm = NSPredicate(format: "name = '" + itemList.name + "'")
        datasource2 = realm.objects(MySickItemsRealm).filter(filterMyItemsRealm)
        let stringDatasource2 = String(datasource2.count)
        cell.updateCount(stringDatasource2)
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var myItemsRealm =  myItems.append(datasource[indexPath.row])
        
        //let num = myItemsarray.count
        //var numOfItems = 0
        let cell = self.TableField2?.dequeueReusableCellWithIdentifier("ItemRowCellID2") as! SickItemRow
        
        let mySickItemsRealm = MySickItemsRealm()
        let itemList = datasource[indexPath.row]
        mySickItemsRealm.category = itemList.category
        mySickItemsRealm.type = itemList.type
        mySickItemsRealm.name = itemList.name
        mySickItemsRealm.price = itemList.price
        try! realm.write {
            realm.add(mySickItemsRealm)
        }
        let filterMyItemsRealm = NSPredicate(format: "name = '" + itemList.name + "'")
        datasource2 = realm.objects(MySickItemsRealm).filter(filterMyItemsRealm)
        print(datasource2, datasource2.count, "im in myitemsrealm after push")
        let stringDatasource2 = String(datasource2.count)
        cell.updateCount(stringDatasource2)
        
        getCount()
        aggregateLabelCount()
        totalLabelCount()
        print(mySickItemsRealm, "this is whats in the index row")
        self.TableField2.reloadData()
        
        
        //print(myItemsRealm)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("testing")
    }
    @IBAction func saveButton(sender: AnyObject) {
        /*let alertController = UIAlertController(title: "Order now?", message:
            "Would you like to order this now?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Not now", style: UIAlertActionStyle.Default,handler: { action in self.performSegueWithIdentifier("alertNoSegue", sender: self) }))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: { action in self.performSegueWithIdentifier("alertSegue", sender: self) }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        */
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.TableField2?.dequeueReusableCellWithIdentifier("ItemRowCellID2") as! SickItemRow
        
        let deletedValue = datasource[indexPath.row].name
        if editingStyle == .Delete {
            
            let filterBroadMyItemsRealm = NSPredicate(format: "name = '" + deletedValue + "' AND category = 'sick'")
            let deletedNotifications = realm.objects(MySickItemsRealm).filter(filterBroadMyItemsRealm)
            let filterMyItemsRealm = NSPredicate(format: "name = '" + deletedValue + "'")
            try! realm.write {
                
                print(deletedNotifications)
                realm.delete(deletedNotifications)
            }
            
            
            datasource2 = realm.objects(MySickItemsRealm).filter(filterMyItemsRealm)
            //print(datasource2, datasource2.count, "im in myitemsrealm after push")
            let stringDatasource2 = String(datasource2.count)
            cell.updateCount(stringDatasource2)
            
            getCount()
            aggregateLabelCount()
            totalLabelCount()
            
            self.TableField2.reloadData()
            
        } else {
            
        }
    }
}

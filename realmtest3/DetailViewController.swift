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



class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableField: UITableView!
    @IBOutlet weak var aggregateLabel: UILabel!
    @IBOutlet weak var totalCount: UILabel!

    var datasource : Results<ItemsList2>!
    var datasource2 : Results<MyItemsRealm>!
    
    let realm = try! Realm()
    var ref = Firebase(url: "https://sosapp2.firebaseio.com/")
    
    var myItemsarray: [Dictionary<String, AnyObject>] = []
    var myItemsCount: [AnyObject] = []
    var myItemsarrayPrice: [Double] = []
   
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        @IBAction func drinksButton(sender: AnyObject) {
        let drinks = NSPredicate(format: "category = 'hangover' AND type = 'drink'")
        datasource = realm.objects(ItemsList2).filter(drinks)
       // aggregateLabelCount() 
        self.TableField.reloadData()
        //print(datasource)
    }
       @IBAction func snackButton(sender: AnyObject) {
        let snacks = NSPredicate(format: "type = 'snack' AND category = 'hangover'")
        datasource = realm.objects(ItemsList2).filter(snacks)
       //aggregateLabelCount()
        self.TableField.reloadData()
       
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //SETTING NAV BAR
        navigationItem.title = "Hangover"
       (navigationController?.navigationBarHidden = false)!
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "goNow")
        
        getData()
        getCount()
        aggregateLabelCount()
        totalLabelCount()
        //SETTING TABLE VIEW
        TableField.dataSource = self
        TableField.delegate = self
        
    }
    
    func goNow(){
        //saveToFirebase()
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConfirmView") as! ConfirmViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        //self.performSegueWithIdentifier("alertSegue", sender: self)
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
        //FILTERING REALM FOR HANGOVER ONLY ITEMS
        let test = NSPredicate(format: "type = 'drink' AND category = 'hangover'")
         datasource = realm.objects(ItemsList2).filter(test)
    }

    
    func totalLabelCount(){
        let myItems = realm.objects(MyItemsRealm)
        //LOOPING THROUGH TO ADD TOGETHER PRICES
        if myItems.count != 0{
            print(myItemsarrayPrice, "this is whats in myitemsarrayprice")
            let numbers = [Double](myItemsarrayPrice)
            let total = numbers.reduce(0, combine: +)
            totalCount.text = String("Total: ") + String(total)
           // print(totalCount.text, "this is the total", total)
        }
          //NOTHING TO LOOP THROUGH
        else{
            totalCount.text = "0"
        }
        
    }
    
    func getCount(){
        let myItems = realm.objects(MyItemsRealm)
        let num = myItems.count
        //CLEARING OUT ARRAY
        myItemsarrayPrice.removeAll()
        //LOOPING THROUGH ADDING TO ARRAY
        for var i = 0; i < num; i++ {
            let intAmount = Double(myItems[i].price)
            if intAmount != nil{
            //myItemsarray.append(["name": myItems[i].name, "price": myItems[i].price, "type": myItems[i].type, "category": myItems[i].category])
            myItemsarrayPrice.append(intAmount!)
            } else {print("im nil") }
            
        }//close forloop
        print(myItemsarrayPrice)
        
    }
    
    
    func aggregateLabelCount(){
        let myItems = realm.objects(MyItemsRealm)
        let num = myItems.count
        if myItems.count > 0{
            aggregateLabel.text = "Items " + String(num)
        }
        else if myItems.count == 0{
            aggregateLabel.text = "Items 0"
        }
        print (myItemsarray)
        
    }

    /*func saveToFirebase(){
                //ALERT
        let alertController = UIAlertController(title: "Order", message: "Do you want to order this now?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes, order", style: UIAlertActionStyle.Default) {
        UIAlertAction in
            self.performSegueWithIdentifier("alertSegue", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: "Not now", style: UIAlertActionStyle.Cancel) {
        UIAlertAction in
            self.performSegueWithIdentifier("alertNoSegue", sender: self)
        NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }*/
    
    
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       
        let cell = self.TableField?.dequeueReusableCellWithIdentifier("ItemRowCellID") as! ItemRow
        let itemList = datasource[indexPath.row]
        cell.updateView(itemList.name)
        
        //FILTERING ITEMS
        let filterMyItemsRealm = NSPredicate(format: "name = '" + itemList.name + "'")
        datasource2 = realm.objects(MyItemsRealm).filter(filterMyItemsRealm)
        let stringDatasource2 = String(datasource2.count)
        //UPDAINTG COUNT
        cell.updateCount(stringDatasource2)
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.TableField?.dequeueReusableCellWithIdentifier("ItemRowCellID") as! ItemRow
        //GETTING INDEX ROW ASSOCIATING TO REALM OBJECT
        let myItemsRealm = MyItemsRealm()
        let itemList = datasource[indexPath.row]
        myItemsRealm.category = itemList.category
        myItemsRealm.type = itemList.type
        myItemsRealm.name = itemList.name
        myItemsRealm.price = itemList.price
        //ADDING TO REALM LIST
        do {
            try realm.write() {
                realm.add(myItemsRealm)
            }
        } catch {
            
            //ALERT IF ERROR
            let alertController = UIAlertController(title: "Error", message: "Couldn't add item to your cart :(", preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
        }//close realm
        
        //FILTERING LIST
        let filterMyItemsRealm = NSPredicate(format: "name = '" + itemList.name + "'")
        datasource2 = realm.objects(MyItemsRealm).filter(filterMyItemsRealm)
        print(datasource2, datasource2.count, "im in myitemsrealm after push")
        //KEEPING COUNT UPDATED
        let stringDatasource2 = String(datasource2.count)
        cell.updateCount(stringDatasource2)
        
        getCount()
        aggregateLabelCount()
        totalLabelCount()
        self.TableField.reloadData()
        
           }
    
   
      
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.TableField?.dequeueReusableCellWithIdentifier("ItemRowCellID") as! ItemRow
        
        let deletedValue = datasource[indexPath.row].name
        //IF DELETING ROW
               if editingStyle == .Delete {
                //FILTER
                let filterBroadMyItemsRealm = NSPredicate(format: "name = '" + deletedValue + "' AND category = 'hangover'")
                let deletedNotifications = realm.objects(MyItemsRealm).filter(filterBroadMyItemsRealm)
                let filterMyItemsRealm = NSPredicate(format: "name = '" + deletedValue + "'")
                //REMOVING DELETED ITEMS FROM REALM
                do {
                    try realm.write() {
                        realm.delete(deletedNotifications)
                    }
                } catch {
                    
                    //ALERT IF ERROR
                    let alertController = UIAlertController(title: "Error", message: "Error trying to remove item from your cart", preferredStyle: .Alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                }//close realm
                
                datasource2 = realm.objects(MyItemsRealm).filter(filterMyItemsRealm)
                let stringDatasource2 = String(datasource2.count)
                cell.updateCount(stringDatasource2)
                
                getCount()
                aggregateLabelCount()
                totalLabelCount()
                
                self.TableField.reloadData()
                
        } else {}
    }//close if
}

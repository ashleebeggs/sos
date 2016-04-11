//
//  MunchiesDetailViewController.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 4/3/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift

class MunchiesDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableField4: UITableView!
    @IBOutlet weak var aggregateLabel4: UILabel!
    @IBOutlet weak var totalCount4: UILabel!
    
    var datasource : Results<ItemsList2>!
    var datasource4 : Results<MyMunchiesItemsRealm>!
    
    let realm = try! Realm()
    
    var myItemsarray: [AnyObject] = []
    var myItemsCount: [AnyObject] = []
    var myItemsarrayPrice: [Double] = []
    
    @IBAction func drinkButton(sender: AnyObject) {
        let drinks = NSPredicate(format: "type = 'drink' AND category = 'munchies'")
        datasource = realm.objects(ItemsList2).filter(drinks)
        self.TableField4.reloadData()
        //print(datasource)
    }
    
    @IBAction func snackButton(sender: AnyObject) {
        let drinks = NSPredicate(format: "type = 'snack' AND category = 'munchies'")
        datasource = realm.objects(ItemsList2).filter(drinks)
        self.TableField4.reloadData()
        //print(datasource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (navigationController?.navigationBarHidden = false)!
        navigationItem.title = "Munchies"
        getData()
        getCount()
        aggregateLabelCount()
        totalLabelCount()
        TableField4.dataSource = self
        TableField4.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        let test = NSPredicate(format: "type = 'drink' AND category = 'munchies'")
        datasource = realm.objects(ItemsList2).filter(test)
        print(datasource)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func totalLabelCount(){
        let myItems = realm.objects(MyMunchiesItemsRealm)
        // print(myItems, "this is whats in label count")
        if myItems.count != 0{
            print(myItemsarrayPrice, "this is whats in myitemsarrayprice")
            let numbers = [Double](myItemsarrayPrice)
            let total = numbers.reduce(0, combine: +)
            totalCount4.text = String("Total: ") + String(total)
            print(totalCount4.text, "this is the total", total)
        }
            
        else{
            totalCount4.text = "0"
        }
        
    }
    
    func getCount(){
        let myItems = realm.objects(MyMunchiesItemsRealm)
        let num = myItems.count
        
        myItemsarrayPrice.removeAll()
        myItemsarray.removeAll()
        for var i = 0; i < num; i++ {
            let intAmount = Double(myItems[i].price)
            if intAmount != nil{
                
                let myItemsArray =  myItemsarray.append(myItems[i].name)
                var myItemsArrayPrice =  myItemsarrayPrice.append(intAmount!)
            } else {print("im nil") }
            
            //print (myItemsArray)
            
        }
        print(myItemsarrayPrice)
        
    }
    
    
    func aggregateLabelCount(){
        let myItems = realm.objects(MyMunchiesItemsRealm)
        let num = myItems.count
        if myItems.count > 0{
            aggregateLabel4.text = "Items " + String(num)
        }
        else if myItems.count == 0{
            aggregateLabel4.text = "Items 0"
        }
        //print (myItemsarray)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.TableField4?.dequeueReusableCellWithIdentifier("ItemRowCellID4") as! MunchiesItemRow
        let itemList = datasource[indexPath.row]
        cell.updateView(itemList.name)
        
        let filterMyItemsRealm = NSPredicate(format: "name = '" + itemList.name + "'")
        datasource4 = realm.objects(MyMunchiesItemsRealm).filter(filterMyItemsRealm)
        let stringDatasource2 = String(datasource4.count)
        cell.updateCount(stringDatasource2)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var myItemsRealm =  myItems.append(datasource[indexPath.row])
        
        //let num = myItemsarray.count
        //var numOfItems = 0
        let cell = self.TableField4?.dequeueReusableCellWithIdentifier("ItemRowCellID4") as! MunchiesItemRow
        
        let myMunchiesItemsRealm = MyMunchiesItemsRealm()
        let itemList = datasource[indexPath.row]
        myMunchiesItemsRealm.category = itemList.category
        myMunchiesItemsRealm.type = itemList.type
        myMunchiesItemsRealm.name = itemList.name
        myMunchiesItemsRealm.price = itemList.price
        try! realm.write {
            realm.add(myMunchiesItemsRealm)
        }
        let filterMyItemsRealm = NSPredicate(format: "name = '" + itemList.name + "'")
        datasource4 = realm.objects(MyMunchiesItemsRealm).filter(filterMyItemsRealm)
        print(datasource4, datasource4.count, "im in myitemsrealm after push")
        let stringDatasource2 = String(datasource4.count)
        cell.updateCount(stringDatasource2)
        
        getCount()
        aggregateLabelCount()
        totalLabelCount()
        print(myMunchiesItemsRealm, "this is whats in the index row")
        self.TableField4.reloadData()
        
        
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
        let cell = self.TableField4?.dequeueReusableCellWithIdentifier("ItemRowCellID4") as! MunchiesItemRow
        
        let deletedValue = datasource[indexPath.row].name
        if editingStyle == .Delete {
            
            let filterBroadMyItemsRealm = NSPredicate(format: "name = '" + deletedValue + "' AND category = 'munchies'")
            let deletedNotifications = realm.objects(MyMunchiesItemsRealm).filter(filterBroadMyItemsRealm)
            let filterMyItemsRealm = NSPredicate(format: "name = '" + deletedValue + "'")
            try! realm.write {
                
                print(deletedNotifications)
                realm.delete(deletedNotifications)
            }
            
            
            datasource4 = realm.objects(MyMunchiesItemsRealm).filter(filterMyItemsRealm)
            //print(datasource2, datasource2.count, "im in myitemsrealm after push")
            let stringDatasource2 = String(datasource4.count)
            cell.updateCount(stringDatasource2)
            
            getCount()
            aggregateLabelCount()
            totalLabelCount()
            
            self.TableField4.reloadData()
            
        } else {
            
        }
    }
    
}
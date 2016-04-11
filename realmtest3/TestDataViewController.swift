//
//  TestDataViewController.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/20/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift


class TestDataViewController: UIViewController {
   

   override func viewDidLoad() {
    
   
        
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
        let newItems = ItemsList2()
        //let realm = try! Realm()
        newItems.category = "sick"
        newItems.type = "drink"
        newItems.name = "water"
        newItems.price = "0.99"
        newItems.id = "2"
        
        /*try! realm.write {
            realm.add(newItems)
        }*/
    
       }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}

//
//  AddAddress.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/29/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import Firebase

class AddAddress: UIViewController,CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    let ref = Firebase(url: "https://sosapp2.firebaseio.com")

    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // (navigationController?.navigationBarHidden = false)!
        
        
    }
    @IBAction func locateMe(sender: AnyObject) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let geoCoder = CLGeocoder()
        let placemark: AnyObject
        let error: NSError
        geoCoder.reverseGeocodeLocation(self.locationManager.location!, completionHandler: { (placemark, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if placemark!.count > 0 {
                let pm = placemark![0] as CLPlacemark
                print(pm.locality, pm.country, pm.postalCode, pm.thoroughfare, pm.administrativeArea, pm.subThoroughfare)
                self.streetField.text = pm.subThoroughfare! + " " + pm.thoroughfare!
                self.cityField.text = pm.locality
                self.stateField.text = pm.administrativeArea
                self.zipField.text = pm.postalCode
                
            } else {
                print("Error with data")
            }
        })

    }
    override func viewWillAppear(animated: Bool) {
        //return (navigationController?.navigationBarHidden = true)!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveNewAddress(sender: AnyObject) {
         ref.observeAuthEventWithBlock({ authData in
        if authData != nil {
            print("working")
        }
        else {
        
            }//close else
        })
        
        let addAddressNew = Address()
        addAddressNew.street = streetField.text!
        addAddressNew.city = cityField.text!
        addAddressNew.state = stateField.text!
        addAddressNew.zipcode = zipField.text!
        
    try! realm.write {
            realm.add(addAddressNew)
        }
        ref.observeAuthEventWithBlock({ authData in
            
        let usersRef = self.ref.childByAppendingPath("users/uid/" + authData.uid + "/address")
        let userlocation = ["address": ["street": self.streetField.text!, "city": self.cityField.text!, "state": self.stateField.text!, "zipcode": self.zipField.text!]]
        usersRef.setValue(userlocation)
            })
        self.dismissViewControllerAnimated(true, completion: nil)
        print(addAddressNew)
    }
   
}

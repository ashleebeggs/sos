//
//  Items.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/20/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit
import RealmSwift


class Items: Object {
    dynamic var fbemail: String =  ""
    dynamic var fbname: String = ""
    dynamic var phone: String = ""
    }

class Address: Object {
    dynamic var street: String =  ""
    dynamic var city: String = ""
    dynamic var state: String = ""
    dynamic var zipcode: String = ""
    
}


class ItemsList2: Object {
    dynamic var category: String =  ""
     dynamic var type: String =  ""
    dynamic var name: String = ""
    dynamic var price: String = ""
    dynamic var id: String = ""
    
}



class MyItemsRealm: Object {
    
    dynamic var category: String =  ""
    dynamic var type: String =  ""
    dynamic var name: String = ""
    dynamic var price: String = ""
   // dynamic var fbemail: String = ""
    
}

class MyTestItemsRealm: Object {
    
    dynamic var category: String =  ""
    dynamic var type: String =  ""
    dynamic var name: String = ""
    dynamic var price: String = ""
    // dynamic var fbemail: String = ""
    
}


class MySickItemsRealm: Object {
    
    dynamic var category: String =  ""
    dynamic var type: String =  ""
    dynamic var name: String = ""
    dynamic var price: String = ""
    // dynamic var fbemail: String = ""
    
}

class MyBUItemsRealm: Object {
    
    dynamic var category: String =  ""
    dynamic var type: String =  ""
    dynamic var name: String = ""
    dynamic var price: String = ""
    // dynamic var fbemail: String = ""
    
}

class MyMunchiesItemsRealm: Object {
    
    dynamic var category: String =  ""
    dynamic var type: String =  ""
    dynamic var name: String = ""
    dynamic var price: String = ""
    // dynamic var fbemail: String = ""
    
}
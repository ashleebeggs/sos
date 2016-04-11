
//
//  ShowAddressItemRow.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/30/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit

class ShowAddressItemRow: UITableViewCell {
    
    //@IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func updateView(labelName:String){
        address.text = labelName
    }
    
    
    
}
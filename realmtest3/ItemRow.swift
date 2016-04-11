//
//  ItemRow.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/24/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//


import UIKit

class ItemRow: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    
    func updateView(labelName:String){
       itemLabel.text = labelName
    }

    func updateCount(labelCount:String){
        if labelCount != "0" {
        itemCountLabel.text = labelCount
        } else {
            itemCountLabel.text = " "
        }
    }

    
    
}
//
//  MunchiesItemRow.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 4/3/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit

class MunchiesItemRow: UITableViewCell {
    
    @IBOutlet weak var munchiesItemLabel: UILabel!
    @IBOutlet weak var munchiesItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func updateView(labelName:String){
        munchiesItemLabel.text = labelName
    }
    
    func updateCount(labelCount:String){
        if labelCount != "0" {
            munchiesItemCount.text = labelCount
        } else {
            munchiesItemCount.text = " "
        }
        
    }
}
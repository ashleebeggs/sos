//
//  BreakupItemRow.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/25/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit

class BreakupItemRow: UITableViewCell {

    @IBOutlet weak var breakupItemLabel: UILabel!
    @IBOutlet weak var breakupItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func updateView(labelName:String){
        breakupItemLabel.text = labelName
    }
    
    func updateCount(labelCount:String){
        if labelCount != "0" {
            breakupItemCount.text = labelCount
        } else {
            breakupItemCount.text = " "
        }
        
    }
}
//
//  SickItemRow.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/25/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//

import UIKit

class SickItemRow: UITableViewCell {
  
    @IBOutlet weak var sickItemLabel: UILabel!
    @IBOutlet weak var sickItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func updateView(labelName:String){
        sickItemLabel.text = labelName
    }
    
    func updateCount(labelCount:String){
        if labelCount != "0" {
            sickItemCount.text = labelCount
        } else {
            sickItemCount.text = " "
        }

}
    
}
